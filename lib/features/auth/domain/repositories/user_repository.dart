import 'dart:io';
import 'package:news_ui_kit/features/auth/data/user_model.dart';

abstract class UserRepository {
  Future<void> saveUserProfile(UserModel user);
  Future<UserModel?> getUserProfile(String uid);
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data);
  Future<void> saveOrUpdateProfile(String uid, Map<String, dynamic> data);
  Future<bool> profileExists(String uid);
  Future<String> uploadProfileImage({required String uid, required File imageFile});
}
