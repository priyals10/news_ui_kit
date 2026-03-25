import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/repositories/news_repository.dart';

/// Use case: search articles by keyword.
class SearchArticlesUseCase {
  final NewsRepository repository;

  SearchArticlesUseCase(this.repository);

  Future<List<NewsArticle>> call({required String query}) {
    return repository.searchArticles(query: query);
  }
}
