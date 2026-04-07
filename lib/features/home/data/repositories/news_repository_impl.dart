import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import 'package:news_ui_kit/core/network_info.dart';
import 'package:news_ui_kit/features/home/data/data_sources/news_remote_data_source.dart';
import 'package:news_ui_kit/features/home/data/models/local_headline.dart';
import 'package:news_ui_kit/features/home/data/models/news_article_model.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final Isar? isar;
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
    if (isar != null) {
      final locals = await isar!.localHeadlines
          .filter()
          .titleContains(query, caseSensitive: false)
          .or()
          .descriptionContains(query, caseSensitive: false)
          .findAll();
      return locals.map((l) => l.toEntity()).toList();
    }
    
    return [];
  }

  Stream<List<NewsArticle>> _fetchWithCache({
    required String category,
    required Future<List<NewsArticleModel>> Function() fetcher,
  }) async* {
    
    bool localDataYielded = false;

    // 1. Yield local data first (Pulse 1: Instant)
    if (isar != null) {
      final locals = await isar!.localHeadlines
          .filter()
          .categoryEqualTo(category)
          .findAll();
      
      if (locals.isNotEmpty) {
        yield locals.map((l) => l.toEntity()).toList();
        localDataYielded = true;
      }
    } 
    
    // Explicit Fallback for failing Isar bounds (Tablet/Simulator locks):
    if (!localDataYielded) {
       final prefs = await SharedPreferences.getInstance();
       final cachedString = prefs.getString('offline_news_cache_$category');
       if (cachedString != null) {
          try {
            final List decoded = json.decode(cachedString);
            final cachedArticles = decoded.map((e) => NewsArticleModel.fromJson(e).toEntity()).toList();
            if (cachedArticles.isNotEmpty) {
              yield cachedArticles;
              localDataYielded = true;
            }
          } catch (_) {}
       }
    }

    // 2. Pulse 2: Fetch and Yield Remote Data if Online
    if (await networkInfo.isConnected) {
      try {
        final models = await fetcher();
        final articles = models.map((m) => m.toEntity()).toList();
        await _updateLocalCache(articles, category, models);
        yield articles;
        return; // Success
      } catch (e) {
        // Failing silently yields previous locals stream items, guaranteeing UI stays intact.
        return;
      }
    }
  }

  Future<void> _updateLocalCache(List<NewsArticle> articles, String category, List<NewsArticleModel> models) async {
    // Save redundantly to SharedPreferences ensuring flawless persistence even if Isar crashes natively.
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = models.map((m) => m.toJson()).toList();
      await prefs.setString('offline_news_cache_$category', json.encode(jsonList));
    } catch (_) {}

    if (isar == null) return;
    
    await isar!.writeTxn(() async {
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

      await isar!.localHeadlines.putAll(locals);
    });
  }
}
