import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> signUp({required String email, required String password});
  Future<User?> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> confirmPasswordReset({required String code, required String newPassword});
  User? get currentUser;
  Stream<User?> get authStateChanges;
}
