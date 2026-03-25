import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signIn({required String email, required String password});
  Future<User?> signUp({required String email, required String password});
  Future<void> signOut();
  Future<void> sendPasswordReset({required String email});
  Future<void> confirmPasswordReset({required String oobCode, required String newPassword});
  User? get currentUser;
  Stream<User?> get authStateChanges;
}
