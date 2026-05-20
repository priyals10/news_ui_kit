import 'package:news_ui_kit/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> saveUserProfile(User user);
  Future<User?> getUserProfile(String uid);
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data);
  Future<void> saveOrUpdateProfile(String uid, Map<String, dynamic> data);
  Future<bool> profileExists(String uid);
  
  /// Uploads profile image. Takes a local file path.
  Future<String> uploadProfileImage({required String uid, required String imagePath});
}
