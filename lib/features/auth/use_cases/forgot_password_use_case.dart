import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'auth_result.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<AuthResult> call({required String email}) async {
    final value = email.trim();
    final errors = <String, String>{};

    // ── Local validation (email only now — Firebase doesn't support mobile reset) ──
    if (value.isEmpty) {
      errors['email'] = AppStrings.pleaseEnterEmailOrMobile;
    } else if (!_isValidEmail(value)) {
      errors['email'] = AppStrings.invalidEmailOrMobile;
    }

    if (errors.isNotEmpty) return AuthResult.failure(errors);

    // ── Firebase call (NEW) ──
    try {
      await _repository.sendPasswordReset(email: value);
      return AuthResult.success(data: value);
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseError(e.code);
      return AuthResult.failure({'email': message});
    }
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$').hasMatch(value);

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'Failed to send reset email. Please try again.';
    }
  }
}