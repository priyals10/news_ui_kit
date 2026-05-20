import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

/// Abstract contract for the bookmark repository.
abstract class BookmarkRepository {
  Future<void> addBookmark(NewsArticle article);
  Future<void> removeBookmark(NewsArticle article);
  Future<bool> isBookmarked(NewsArticle article);
  Future<List<NewsArticle>> getBookmarks();
  Stream<List<NewsArticle>> getBookmarksStream();
}
