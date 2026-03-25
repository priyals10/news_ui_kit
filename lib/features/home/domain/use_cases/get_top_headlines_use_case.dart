import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/repositories/news_repository.dart';

/// Use case: fetch top headlines.
/// The BLoC calls this instead of the repository directly.
class GetTopHeadlinesUseCase {
  final NewsRepository repository;

  GetTopHeadlinesUseCase(this.repository);

  Future<List<NewsArticle>> call({String country = 'us'}) {
    return repository.getTopHeadlines(country: country);
  }
}
