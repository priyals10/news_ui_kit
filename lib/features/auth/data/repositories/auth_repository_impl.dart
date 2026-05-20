import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart' as domain;

class AuthRepositoryImpl implements domain.AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({firebase.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  @override
  User? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Stream<User?> get authStateChanges => 
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  Future<User?> signIn({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapFirebaseUser(credential.user);
  }

  @override
  Future<User?> signUp({required String email, required String password}) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapFirebaseUser(credential.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> confirmPasswordReset({required String code, required String newPassword}) async {
    await _firebaseAuth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  /// Translates a Firebase User into a clean Domain User entity.
  User? _mapFirebaseUser(firebase.User? firebaseUser) {
    if (firebaseUser == null) return null;
    
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      username: firebaseUser.displayName ?? '',
      fullName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      // The other fields like bio/website will be fetched via UserRepository from Firestore
    );
  }
}
