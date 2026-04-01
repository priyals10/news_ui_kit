import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

/// Abstract contract for the news repository.
/// The domain/use-case layer depends on this — NOT on the implementation.
abstract class NewsRepository {
  Stream<List<NewsArticle>> getTopHeadlines({String country = 'us'});
  Stream<List<NewsArticle>> getTopHeadlinesByCategory({
    String country = 'us',
    required String category,
  });
  Future<List<NewsArticle>> searchArticles({required String query});
}
