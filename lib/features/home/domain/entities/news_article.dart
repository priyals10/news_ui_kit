/// Pure domain entity — no JSON, no API details.
/// This is what the rest of the app (BLoC, UI) works with.
class NewsArticle {
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

  NewsArticle({
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

  /// Returns the image URL wrapped in wsrv.nl proxy to bypass CORS and
  /// fix http images on Android. Use this for display only.
  /// imageUrl (raw) is used as the stable cache key.
  String get proxiedImageUrl {
    if (imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('https://wsrv.nl/')) return imageUrl; // already proxied
    return 'https://wsrv.nl/?url=${Uri.encodeComponent(imageUrl)}';
  }
}
