import 'package:image_picker/image_picker.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/auth/domain/repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository repository;
  GetUserProfileUseCase(this.repository);

  Future<UserModel?> call(String uid) {
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

  /// Updated to use [XFile] to avoid dart:io dependency on web.
  Future<String> call({required String uid, required XFile imageFile}) {
    return repository.uploadProfileImage(uid: uid, imageFile: imageFile);
  }
}
