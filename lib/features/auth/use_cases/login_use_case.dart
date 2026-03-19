import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'auth_result.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthResult> call({
    required String email,
    required String password,
  }) async {
    final errors = <String, String>{};

    // ── Local validation (same as before, but "email" instead of "username") ──
    if (email.isEmpty) {
      errors['email'] = AppStrings.emailRequired;
    } else if (!_isValidEmail(email)) {
      errors['email'] = AppStrings.invalidEmail;
    }

    final pwError = _validatePassword(password);
    if (pwError != null) errors['password'] = pwError;

    if (errors.isNotEmpty) return AuthResult.failure(errors);

    // ── Firebase call (NEW) ──
    try {
      await _repository.signIn(email: email, password: password);
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseError(e.code);
      return AuthResult.failure({'email': message});
    }
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$').hasMatch(value);

  String? _validatePassword(String password) {
    if (password.isEmpty) return AppStrings.passwordRequired;
    if (password.length < 8) return AppStrings.passwordMinLength;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return AppStrings.passwordUppercase;
    if (!RegExp(r'[0-9]').hasMatch(password)) return AppStrings.passwordNumber;
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return AppStrings.passwordSpecialChar;
    }
    return null;
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return 'Login failed. Please try again.';
    }
  }
}