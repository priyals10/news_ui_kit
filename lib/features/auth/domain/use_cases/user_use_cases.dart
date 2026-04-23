import 'package:news_ui_kit/features/auth/domain/entities/user.dart';
import 'package:news_ui_kit/features/auth/domain/repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository repository;
  GetUserProfileUseCase(this.repository);

  Future<User?> call(String uid) {
    return repository.getUserProfile(uid);
  }
}

class UpdateUserProfileUseCase {
  final UserRepository repository;
  UpdateUserProfileUseCase(this.repository);

  Future<void> call(String uid, Map<String, dynamic> data) {
    return repository.updateUserProfile(uid, data);
  }
}

class SaveOrUpdateProfileUseCase {
  final UserRepository repository;
  SaveOrUpdateProfileUseCase(this.repository);

  Future<void> call(String uid, Map<String, dynamic> data) {
    return repository.saveOrUpdateProfile(uid, data);
  }
}

class UploadProfileImageUseCase {
  final UserRepository repository;
  UploadProfileImageUseCase(this.repository);

  /// Takes a local image path and returns the uploaded URL.
  Future<String> call({required String uid, required String imagePath}) {
    return repository.uploadProfileImage(uid: uid, imagePath: imagePath);
  }
}
