import 'package:isar/isar.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';

part 'local_news.g.dart';

@collection
class LocalNews {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String firestoreId;

  late String authorId;
  late String authorName;
  late String authorImage;

  @Index(type: IndexType.value)
  late String title;

  late String content;
  late String coverImageUrl;
  late DateTime createdAt;

  bool isSynced = true; // Tracks if it matches Firestore

  UserNewsModel toModel() {
    return UserNewsModel(
      id: firestoreId,
      authorId: authorId,
      authorName: authorName,
      authorImage: authorImage,
      title: title,
      content: content,
      coverImageUrl: coverImageUrl,
      createdAt: createdAt,
    );
  }
}
