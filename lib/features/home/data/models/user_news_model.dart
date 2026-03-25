class UserNewsModel {
  final String id;
  final String authorId;
  final String authorName;
  final String authorImage;
  final String title;
  final String content;
  final String coverImageUrl;
  final DateTime createdAt;

  UserNewsModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorImage,
    required this.title,
    required this.content,
    required this.coverImageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'title': title,
      'content': content,
      'coverImageUrl': coverImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserNewsModel.fromJson(Map<String, dynamic> json) {
    return UserNewsModel(
      id: json['id'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorImage: json['authorImage'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
  
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
