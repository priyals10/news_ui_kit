import 'package:isar/isar.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

part 'local_headline.g.dart';

@collection
class LocalHeadline {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('category')], unique: true, replace: true)
  late String url; // Unique combination of URL + Category

  late String sourceId;
  late String sourceName;
  late String author;

  @Index(type: IndexType.value)
  late String title;

  late String description;
  late String imageUrl;
  late DateTime? publishedAt;
  late String content;
  late String category;

  /// Convert to domain entity for UI
  NewsArticle toEntity() {
    return NewsArticle(
      sourceId: sourceId,
      sourceName: sourceName,
      author: author,
      title: title,
      description: description,
      url: url,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      content: content,
    );
  }
}
