import '../../domain/entities/user_news.dart';
import 'local_news.dart';

class UserNewsModel extends UserNews {
  UserNewsModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.authorImage,
    required super.title,
    required super.content,
    required super.coverImageUrl,
    required super.createdAt,
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

  factory UserNewsModel.fromEntity(UserNews news) {
    return UserNewsModel(
      id: news.id,
      authorId: news.authorId,
      authorName: news.authorName,
      authorImage: news.authorImage,
      title: news.title,
      content: news.content,
      coverImageUrl: news.coverImageUrl,
      createdAt: news.createdAt,
    );
  }

  LocalNews toLocal({bool isSynced = true}) {
    return LocalNews()
      ..firestoreId = id
      ..authorId = authorId
      ..authorName = authorName
      ..authorImage = authorImage
      ..title = title
      ..content = content
      ..coverImageUrl = coverImageUrl
      ..createdAt = createdAt
      ..isSynced = isSynced;
  }
}
