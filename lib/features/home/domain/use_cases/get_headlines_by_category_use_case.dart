import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/repositories/news_repository.dart';

/// Use case: fetch top headlines filtered by category.
class GetHeadlinesByCategoryUseCase {
  final NewsRepository repository;

  GetHeadlinesByCategoryUseCase(this.repository);

  Stream<List<NewsArticle>> call({required String category, String country = 'us'}) {
    return repository.getTopHeadlinesByCategory(
      category: category,
      country: country,
    );
  }
}
