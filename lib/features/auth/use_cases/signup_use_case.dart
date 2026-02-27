import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'auth_result.dart';

class SignupUseCase {
  AuthResult call({
    required String username,
    required String password,
    required String confirmPassword,
  }) {
    final errors = <String, String>{};

    if (username.isEmpty) {
      errors['username'] = AppStrings.usernameRequired;
    }

    final pwError = _validatePassword(password);
    if (pwError != null) errors['password'] = pwError;

    if (confirmPassword.isEmpty) {
      errors['confirmPassword'] = AppStrings.confirmPasswordRequired;
    } else if (confirmPassword != password) {
      errors['confirmPassword'] = AppStrings.passwordsDoNotMatch;
    }

    if (errors.isEmpty) return AuthResult.success();
    return AuthResult.failure(errors);

  }

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
