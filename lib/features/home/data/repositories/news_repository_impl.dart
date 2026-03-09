import 'package:news_ui_kit/features/home/data/data_sources/news_remote_data_source.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/repositories/news_repository.dart';

/// Concrete implementation of [NewsRepository].
/// Calls the data source, converts models → entities, and returns them.
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NewsArticle>> getTopHeadlines({String country = 'us'}) async {
    final models = await remoteDataSource.fetchTopHeadlines(country: country);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<NewsArticle>> getTopHeadlinesByCategory({
    String country = 'us',
    required String category,
  }) async {
    final models = await remoteDataSource.fetchTopHeadlinesByCategory(
      country: country,
      category: category,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<NewsArticle>> searchArticles({required String query}) async {
    final models = await remoteDataSource.searchArticles(query: query);
    return models.map((m) => m.toEntity()).toList();
  }
}
