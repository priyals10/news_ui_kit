import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // ── Sign Up ──
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // ── Sign In ──
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // ── Send Password Reset Email ──
  Future<void> sendPasswordReset({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // ── Sign Out ──
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // ── Current User ──
  User? get currentUser => _firebaseAuth.currentUser;

  // ── Auth State Stream ──
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}