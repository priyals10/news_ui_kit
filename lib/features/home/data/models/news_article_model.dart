import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';

/// Data-layer model that knows how to parse NewsAPI JSON.
/// Converts to the pure [NewsArticle] entity via [toEntity()].
class NewsArticleModel {
  final String authorId;
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
    this.authorId = '',
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

  factory NewsArticleModel.fromEntity(NewsArticle article) {
    return NewsArticleModel(
      authorId: article.authorId,
      sourceId: article.sourceId,
      sourceName: article.sourceName,
      author: article.author,
      title: article.title,
      description: article.description,
      url: article.url,
      imageUrl: article.imageUrl,
      publishedAt: article.publishedAt,
      content: article.content,
    );
  }

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      authorId: json['authorId'] ?? '',
      sourceId: json['source']?['id'] ?? '',
      sourceName: json['source']?['name'] ?? '',
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: _fixImageUrl(json['urlToImage']),
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'source': {
        'id': sourceId,
        'name': sourceName,
      },
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      // Store the raw URL (imageUrl is already raw since _fixImageUrl now returns raw)
      'urlToImage': imageUrl,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
    };
  }

  static String _fixImageUrl(dynamic url) {
    if (url == null || url is! String || url.isEmpty) return '';
    // Strip wsrv.nl wrapper if it was previously stored wrapped
    if (url.startsWith('https://wsrv.nl/?url=')) {
      return Uri.decodeComponent(url.replaceFirst('https://wsrv.nl/?url=', ''));
    }
    return url;
  }

  /// Returns the image URL wrapped in the wsrv.nl proxy for display.
  static String proxyUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';
    return 'https://wsrv.nl/?url=${Uri.encodeComponent(rawUrl)}';
  }

  /// Converts this API model to a pure domain entity.
  NewsArticle toEntity() {
    return NewsArticle(
      authorId: authorId,
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
