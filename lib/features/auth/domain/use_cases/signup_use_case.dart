import 'package:news_ui_kit/core/constants/app_strings.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
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

    // ── Repository call (Abstract) ──
    try {
      final user = await _authRepository.signUp(email: email, password: password);
      
      if (user != null) {
        // Create initial user profile in Firestore
        // Note: We use the User entity here, not the Model.
        final newUser = User(
          uid: user.uid,
          email: user.email,
          username: email.split('@')[0],
          fullName: email.split('@')[0].toUpperCase(),
          createdAt: DateTime.now(),
        );
        
        await _userRepository.saveUserProfile(newUser);
      }
      
      return AuthResult.success();
    } catch (e) {
      // In a real app, we might map specific repo errors to strings here.
      // For now, we return a generic failure message.
      return AuthResult.failure({'email': e.toString()});
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
}
