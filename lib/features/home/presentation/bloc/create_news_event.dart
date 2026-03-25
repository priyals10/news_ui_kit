import 'package:equatable/equatable.dart';

abstract class CreateNewsEvent extends Equatable {
  const CreateNewsEvent();

  @override
  List<Object?> get props => [];
}

/// Pick/change the cover image from gallery.
class PickCoverImage extends CreateNewsEvent {
  const PickCoverImage();
}

/// Publish a brand-new news post.
class PublishNews extends CreateNewsEvent {
  const PublishNews({
    required this.title,
    required this.content,
    this.imageFilePath,
    this.existingImageUrl,
  });

  final String title;
  final String content;
  /// Local file path of newly selected image, or null if not changed.
  final String? imageFilePath;
  /// Existing remote URL in edit mode, or null for a new post.
  final String? existingImageUrl;

  @override
  List<Object?> get props => [title, content, imageFilePath, existingImageUrl];
}

/// Update an existing news post.
class UpdateNews extends CreateNewsEvent {
  const UpdateNews({
    required this.newsId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.imageFilePath,
    this.existingImageUrl,
  });

  final String newsId;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? imageFilePath;
  final String? existingImageUrl;

  @override
  List<Object?> get props => [newsId, title, content, imageFilePath, existingImageUrl];
}

/// Delete an existing news post from the create/edit screen.
class DeleteNews extends CreateNewsEvent {
  const DeleteNews({required this.newsId});

  final String newsId;

  @override
  List<Object?> get props => [newsId];
}
