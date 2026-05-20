import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_ui_kit/features/auth/domain/entities/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the profile screen is first opened.
class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

/// Triggered when the user saves edits in EditProfileScreen.
class UpdateProfile extends ProfileEvent {
  const UpdateProfile({
    required this.uid,
    required this.updatedFields,
    this.newProfileImage,
    required this.currentUser,
  });

  final String uid;
  final Map<String, dynamic> updatedFields;
  /// Newly picked local image file, or null if unchanged.
  final XFile? newProfileImage;
  final User currentUser;

  @override
  List<Object?> get props => [uid, updatedFields, newProfileImage];
}

/// Triggered when the user taps "Delete" on one of their news posts.
class DeleteUserNewsPost extends ProfileEvent {
  const DeleteUserNewsPost({required this.newsId});

  final String newsId;

  @override
  List<Object?> get props => [newsId];
}
