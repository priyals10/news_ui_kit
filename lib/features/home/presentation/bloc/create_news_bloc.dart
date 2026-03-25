import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/services/cloudinary_service.dart';
import 'package:news_ui_kit/core/utils/media_picker_helper.dart';
import 'package:news_ui_kit/features/home/domain/repositories/user_news_repository.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:news_ui_kit/features/auth/domain/use_cases/user_use_cases.dart';
import 'package:image_picker/image_picker.dart';
import 'create_news_event.dart';
import 'create_news_state.dart';

/// Manages all logic for creating or editing a news post.
///
/// API calls (Cloudinary upload, Firestore save) live here — not in the UI.
class CreateNewsBloc extends Bloc<CreateNewsEvent, CreateNewsState> {
  final GetUserProfileUseCase _getUserProfile;
  final CreateUserNewsUseCase _createUserNews;
  final UpdateUserNewsUseCase _updateUserNews;
  final DeleteUserNewsUseCase _deleteUserNews;

  CreateNewsBloc({
    required GetUserProfileUseCase getUserProfile,
    required CreateUserNewsUseCase createUserNews,
    required UpdateUserNewsUseCase updateUserNews,
    required DeleteUserNewsUseCase deleteUserNews,
  })  : _getUserProfile = getUserProfile,
        _createUserNews = createUserNews,
        _updateUserNews = updateUserNews,
        _deleteUserNews = deleteUserNews,
        super(const CreateNewsInitial()) {
    on<PickCoverImage>(_onPickCoverImage);
    on<PublishNews>(_onPublishNews);
    on<UpdateNews>(_onUpdateNews);
    on<DeleteNews>(_onDeleteNews);
  }

  // ── Pick image from gallery ───────────────────────────────────────────────

  Future<void> _onPickCoverImage(
    PickCoverImage event,
    Emitter<CreateNewsState> emit,
  ) async {
    final file = await MediaPickerHelper.pickFromGallery();
    if (file != null) {
      emit(CoverImagePicked(imagePath: file.path));
    }
  }

  // ── Publish new news post ─────────────────────────────────────────────────

  Future<void> _onPublishNews(
    PublishNews event,
    Emitter<CreateNewsState> emit,
  ) async {
    emit(const CreateNewsLoading());

    try {
      final currUser = FirebaseAuth.instance.currentUser;
      if (currUser == null) {
        emit(const CreateNewsFailure(message: 'Not logged in.'));
        return;
      }

      final userProfile = await _getUserProfile(currUser.uid);
      final authorName = userProfile?.fullName ?? userProfile?.username ?? 'Anonymous';
      final authorImage = userProfile?.photoUrl ?? '';

      String? coverImageUrl = event.existingImageUrl;
      if (event.imageFilePath != null) {
        coverImageUrl = await CloudinaryService.uploadImage(
          XFile(event.imageFilePath!),
        );
        if (coverImageUrl == null) {
          throw Exception('Failed to upload image.');
        }
      }

      final news = UserNewsModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: currUser.uid,
        authorName: authorName,
        authorImage: authorImage,
        title: event.title,
        content: event.content,
        coverImageUrl: coverImageUrl ?? '',
        createdAt: DateTime.now(),
      );

      await _createUserNews(news);

      emit(const CreateNewsSuccess());
    } catch (e) {
      emit(CreateNewsFailure(message: e.toString()));
    }
  }

  // ── Update existing news post ─────────────────────────────────────────────

  Future<void> _onUpdateNews(
    UpdateNews event,
    Emitter<CreateNewsState> emit,
  ) async {
    emit(const CreateNewsLoading());

    try {
      final currUser = FirebaseAuth.instance.currentUser;
      if (currUser == null) {
        emit(const CreateNewsFailure(message: 'Not logged in.'));
        return;
      }

      final userProfile = await _getUserProfile(currUser.uid);
      final authorName = userProfile?.fullName ?? userProfile?.username ?? 'Anonymous';
      final authorImage = userProfile?.photoUrl ?? '';

      String? coverImageUrl = event.existingImageUrl;
      if (event.imageFilePath != null) {
        coverImageUrl = await CloudinaryService.uploadImage(
          XFile(event.imageFilePath!),
        );
        if (coverImageUrl == null) {
          throw Exception('Failed to upload new image.');
        }
      }

      final updated = UserNewsModel(
        id: event.newsId,
        authorId: currUser.uid,
        authorName: authorName,
        authorImage: authorImage,
        title: event.title,
        content: event.content,
        coverImageUrl: coverImageUrl ?? '',
        createdAt: event.createdAt,
      );

      await _updateUserNews(updated);

      emit(const CreateNewsSuccess());
    } catch (e) {
      emit(CreateNewsFailure(message: e.toString()));
    }
  }

  // ── Delete news post ──────────────────────────────────────────────────────

  Future<void> _onDeleteNews(
    DeleteNews event,
    Emitter<CreateNewsState> emit,
  ) async {
    emit(const CreateNewsLoading());
    try {
      await _deleteUserNews(event.newsId);
      emit(const CreateNewsSuccess());
    } catch (e) {
      emit(CreateNewsFailure(message: e.toString()));
    }
  }
}
