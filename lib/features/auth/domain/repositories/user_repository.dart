import 'package:image_picker/image_picker.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';

abstract class UserRepository {
  Future<void> saveUserProfile(UserModel user);
  Future<UserModel?> getUserProfile(String uid);
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data);
  Future<void> saveOrUpdateProfile(String uid, Map<String, dynamic> data);
  Future<bool> profileExists(String uid);
  /// Updated to use [XFile] to avoid dart:io dependency on web.
  Future<String> uploadProfileImage({required String uid, required XFile imageFile});
}
