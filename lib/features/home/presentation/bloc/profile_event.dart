import 'package:equatable/equatable.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';

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
    this.newProfileImagePath,
    required this.currentUser,
  });

  final String uid;
  final Map<String, dynamic> updatedFields;
  /// Path to newly picked local image file, or null if unchanged.
  final String? newProfileImagePath;
  final UserModel currentUser;

  @override
  List<Object?> get props => [uid, updatedFields, newProfileImagePath];
}

/// Triggered when the user taps "Delete" on one of their news posts.
class DeleteUserNewsPost extends ProfileEvent {
  const DeleteUserNewsPost({required this.newsId});

  final String newsId;

  @override
  List<Object?> get props => [newsId];
}
