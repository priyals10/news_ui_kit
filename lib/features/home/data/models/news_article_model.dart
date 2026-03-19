import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

/// Data-layer model that knows how to parse NewsAPI JSON.
/// Converts to the pure [NewsArticle] entity via [toEntity()].
class NewsArticleModel {
  final String sourceId;
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime? publishedAt;
  final String content;

  NewsArticleModel({
    this.sourceId = '',
    this.sourceName = '',
    this.author = '',
    this.title = '',
    this.description = '',
    this.url = '',
    this.imageUrl = '',
    this.publishedAt,
    this.content = '',
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      sourceId: json['source']?['id'] ?? '',
      sourceName: json['source']?['name'] ?? '',
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      content: json['content'] ?? '',
    );
  }

  /// Converts this API model to a pure domain entity.
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
