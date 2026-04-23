import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/auth/domain/entities/user.dart';
import 'package:news_ui_kit/features/home/domain/entities/user_news.dart';
import 'package:news_ui_kit/features/home/domain/use_cases/user_news_use_cases.dart';
import 'package:news_ui_kit/features/auth/domain/use_cases/user_use_cases.dart';

import 'profile_event.dart';
import 'profile_state.dart';

/// Manages all state for the Profile and Edit Profile screens.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase _getUserProfile;
  final SaveOrUpdateProfileUseCase _saveOrUpdateProfile;
  final UploadProfileImageUseCase _uploadProfileImage;
  final GetUserNewsUseCase _getUserNews;
  final DeleteUserNewsUseCase _deleteUserNews;

  ProfileBloc({
    required GetUserProfileUseCase getUserProfile,
    required SaveOrUpdateProfileUseCase saveOrUpdateProfile,
    required UploadProfileImageUseCase uploadProfileImage,
    required GetUserNewsUseCase getUserNews,
    required DeleteUserNewsUseCase deleteUserNews,
  })  : _getUserProfile = getUserProfile,
        _saveOrUpdateProfile = saveOrUpdateProfile,
        _uploadProfileImage = uploadProfileImage,
        _getUserNews = getUserNews,
        _deleteUserNews = deleteUserNews,
        super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteUserNewsPost>(_onDeleteUserNewsPost);
  }

  // ── Load profile + user news ──────────────────────────────────────────────

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final firebaseUser = fb.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    emit(const ProfileLoading());

    try {
      final user = await _getUserProfile(firebaseUser.uid);
      final resolvedUser = user ??
          User(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            fullName: firebaseUser.displayName ?? '',
            photoUrl: firebaseUser.photoURL ?? '',
            createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
          );

      // Emit user data first, then load news asynchronously to keep UI snappy
      emit(ProfileLoaded(user: resolvedUser, userNews: const [], isNewsLoading: true));

      final List<UserNews> news = await _getUserNews(firebaseUser.uid);

      if (state is ProfileLoaded) {
        emit((state as ProfileLoaded).copyWith(
          userNews: news,
          isNewsLoading: false,
        ));
      }
    } catch (_) {
      final fallback = User(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      );
      emit(ProfileLoaded(user: fallback, userNews: const [], isNewsLoading: false));
    }
  }

  // ── Update profile (save edits from EditProfileScreen) ───────────────────

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileUpdating());

    try {
      String photoUrl = event.currentUser.photoUrl;

      if (event.newProfileImage != null) {
        photoUrl = await _uploadProfileImage(
          uid: event.uid,
          imagePath: event.newProfileImage!.path,
        );
      }

      final updatedFields = {
        ...event.updatedFields,
        'photoUrl': photoUrl,
      };

      await _saveOrUpdateProfile(event.uid, updatedFields);

      emit(const ProfileUpdateSuccess());

      // Reload profile after successful update
      add(const LoadProfile());
    } catch (e) {
      emit(ProfileError(message: 'Failed to update profile: $e'));
    }
  }

  // ── Delete a user news post ───────────────────────────────────────────────

  Future<void> _onDeleteUserNewsPost(
    DeleteUserNewsPost event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    // Optimistic update: remove immediately from local list
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(
        userNews: currentState.userNews
            .where((n) => n.id != event.newsId)
            .toList(),
      ));
    }

    try {
      await _deleteUserNews(event.newsId);
      // Sync with server to ensure consistency
      add(const LoadProfile());
    } catch (e) {
      // If delete fails, reload to restore correct state
      add(const LoadProfile());
    }
  }
}
