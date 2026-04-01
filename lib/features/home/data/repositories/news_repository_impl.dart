import 'package:isar/isar.dart';
import 'package:news_ui_kit/core/network_info.dart';
import 'package:news_ui_kit/features/home/data/data_sources/news_remote_data_source.dart';
import 'package:news_ui_kit/features/home/data/models/local_headline.dart';
import 'package:news_ui_kit/features/home/data/models/news_article_model.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final Isar isar;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl(this.remoteDataSource, this.isar, this.networkInfo);

  @override
  Stream<List<NewsArticle>> getTopHeadlines({String country = 'us'}) async* {
    yield* _fetchWithCache(
      category: 'All',
      fetcher: () => remoteDataSource.fetchTopHeadlines(country: country),
    );
  }

  @override
  Stream<List<NewsArticle>> getTopHeadlinesByCategory({
    String country = 'us',
    required String category,
  }) async* {
    yield* _fetchWithCache(
      category: category,
      fetcher: () => remoteDataSource.fetchTopHeadlinesByCategory(
        country: country,
        category: category,
      ),
    );
  }

  @override
  Future<List<NewsArticle>> searchArticles({required String query}) async {
    // Search remains a specialized case
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.searchArticles(query: query);
        return models.map((m) => m.toEntity()).toList();
      } catch (_) {}
    }
    
    // Offline local search
    final locals = await isar.localHeadlines
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .descriptionContains(query, caseSensitive: false)
        .findAll();
    return locals.map((l) => l.toEntity()).toList();
  }

  /// Internal helper to sync API data with Local Disk using Streams
  Stream<List<NewsArticle>> _fetchWithCache({
    required String category,
    required Future<List<NewsArticleModel>> Function() fetcher,
  }) async* {
    // 1. Yield local data first (Pulse 1: Instant)
    final locals = await isar.localHeadlines
        .filter()
        .categoryEqualTo(category)
        .findAll();
    yield locals.map((l) => l.toEntity()).toList();

    // 2. Pulse 2: Fetch and Yield Remote Data if Online
    if (await networkInfo.isConnected) {
      try {
        final models = await fetcher();
        final articles = models.map((m) => m.toEntity()).toList();
        await _updateLocalCache(articles, category);
        yield articles;
      } catch (_) {
        // Silently fail, Pulse 1 is already shown
      }
    }
  }

  Future<void> _updateLocalCache(List<NewsArticle> articles, String category) async {
    await isar.writeTxn(() async {
      final locals = articles.map((a) {
        return LocalHeadline()
          ..url = a.url
          ..sourceId = a.sourceId
          ..sourceName = a.sourceName
          ..author = a.author
          ..title = a.title
          ..description = a.description
          ..imageUrl = a.imageUrl
          ..publishedAt = a.publishedAt
          ..content = a.content
          ..category = category;
      }).toList();

      await isar.localHeadlines.putAll(locals);
    });
  }
}
