/// Pure domain entity — no JSON, no API details.
/// This is what the rest of the app (BLoC, UI) works with.
class NewsArticle {
  final String sourceId;
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime? publishedAt;
  final String content;

  NewsArticle({
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

  Map<String, dynamic> toJson() {
    return {
      'sourceId': sourceId,
      'sourceName': sourceName,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
    };
  }

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      sourceId: json['sourceId'] ?? '',
      sourceName: json['sourceName'] ?? '',
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      publishedAt: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt']) 
          : null,
      content: json['content'] ?? '',
    );
  }

  /// Returns a human-readable "time ago" string from publishedAt.
  String get timeAgo {
    if (publishedAt == null) return '';
    final diff = DateTime.now().difference(publishedAt!);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
