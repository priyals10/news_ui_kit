import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

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
    this.imageFile,
    this.existingImageUrl,
  });

  final String title;
  final String content;
  /// Newly picked cross-platform image file, or null if not changed.
  final XFile? imageFile;
  /// Existing remote URL in edit mode, or null for a new post.
  final String? existingImageUrl;

  @override
  List<Object?> get props => [title, content, imageFile, existingImageUrl];
}

/// Update an existing news post.
class UpdateNews extends CreateNewsEvent {
  const UpdateNews({
    required this.newsId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.imageFile,
    this.existingImageUrl,
  });

  final String newsId;
  final String title;
  final String content;
  final DateTime createdAt;
  final XFile? imageFile;
  final String? existingImageUrl;

  @override
  List<Object?> get props => [newsId, title, content, imageFile, existingImageUrl];
}

/// Delete an existing news post from the create/edit screen.
class DeleteNews extends CreateNewsEvent {
  const DeleteNews({required this.newsId});

  final String newsId;

  @override
  List<Object?> get props => [newsId];
}
