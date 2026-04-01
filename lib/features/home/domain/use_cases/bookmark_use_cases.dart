import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/repositories/bookmark_repository.dart';

class AddBookmarkUseCase {
  final BookmarkRepository repository;

  AddBookmarkUseCase(this.repository);

  Future<void> call(NewsArticle article) {
    return repository.addBookmark(article);
  }
}

class RemoveBookmarkUseCase {
  final BookmarkRepository repository;

  RemoveBookmarkUseCase(this.repository);

  Future<void> call(NewsArticle article) {
    return repository.removeBookmark(article);
  }
}

class GetBookmarksUseCase {
  final BookmarkRepository repository;

  GetBookmarksUseCase(this.repository);

  Future<List<NewsArticle>> call() {
    return repository.getBookmarks();
  }
}

class IsBookmarkedUseCase {
  final BookmarkRepository repository;

  IsBookmarkedUseCase(this.repository);

  Future<bool> call(NewsArticle article) {
    return repository.isBookmarked(article);
  }
}

class GetBookmarksStreamUseCase {
  final BookmarkRepository repository;

  GetBookmarksStreamUseCase(this.repository);

  Stream<List<NewsArticle>> call() {
    return repository.getBookmarksStream();
  }
}
