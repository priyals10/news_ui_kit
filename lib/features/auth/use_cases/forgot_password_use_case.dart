import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'auth_result.dart';

class ForgotPasswordUseCase {
  AuthResult call({required String emailOrMobile}) {
    final value = emailOrMobile.trim();
    final errors = <String, String>{};

    if (value.isEmpty) {
      errors['email'] = AppStrings.pleaseEnterEmailOrMobile;
    } else if (!_isValidEmail(value) && !_isValidMobile(value)) {
      errors['email'] = AppStrings.invalidEmailOrMobile;
    }

    if (errors.isEmpty) return AuthResult.success(data: value);
    return AuthResult.failure(errors);

  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$').hasMatch(value);

  bool _isValidMobile(String value) =>
      RegExp(r'^[0-9]{10}$').hasMatch(value);
}
