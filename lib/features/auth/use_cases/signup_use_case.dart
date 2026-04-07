import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/auth/domain/repositories/user_repository.dart';
import 'auth_result.dart';

class SignupUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignupUseCase(this._authRepository, this._userRepository);

  Future<AuthResult> call({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final errors = <String, String>{};

    // ── Local validation ──
    if (email.isEmpty) {
      errors['email'] = AppStrings.emailRequired;
    } else if (!_isValidEmail(email)) {
      errors['email'] = AppStrings.invalidEmail;
    }

    final pwError = _validatePassword(password);
    if (pwError != null) errors['password'] = pwError;

    if (confirmPassword.isEmpty) {
      errors['confirmPassword'] = AppStrings.confirmPasswordRequired;
    } else if (confirmPassword != password) {
      errors['confirmPassword'] = AppStrings.passwordsDoNotMatch;
    }

    if (errors.isNotEmpty) return AuthResult.failure(errors);

    // ── Firebase call ──
    try {
      final user = await _authRepository.signUp(email: email, password: password);
      
      if (user != null) {
        // Create initial user profile in Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? email,
          username: email.split('@')[0],
          fullName: email.split('@')[0].toUpperCase(),
        );
        
        await _userRepository.saveUserProfile(userModel);
      }
      
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseError(e.code);
      return AuthResult.failure({'email': message});
    } catch (e) {
      return AuthResult.failure({'email': 'An unexpected error occurred during signup.'});
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
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password sign-up is not enabled.';
      default:
        return 'Sign up failed. Please try again.';
    }
  }
}
