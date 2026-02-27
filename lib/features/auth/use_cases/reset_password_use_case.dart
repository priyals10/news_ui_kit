import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'auth_result.dart';

class ResetPasswordUseCase {
  AuthResult call({
    required String newPassword,
    required String confirmPassword,
  }) {
    final errors = <String, String>{};

    final pwError = _validatePassword(newPassword);
    if (pwError != null) errors['newPassword'] = pwError;

    if (confirmPassword.isEmpty) {
      errors['confirmPassword'] = AppStrings.pleaseConfirmPassword;
    } else if (confirmPassword != newPassword) {
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
