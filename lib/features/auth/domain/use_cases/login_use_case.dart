import 'package:news_ui_kit/core/constants/app_strings.dart';
import '../repositories/auth_repository.dart';
import 'auth_result.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthResult> call({
    required String email,
    required String password,
  }) async {
    final errors = <String, String>{};

    if (email.isEmpty) {
      errors['email'] = AppStrings.emailRequired;
    } else if (!_isValidEmail(email)) {
      errors['email'] = AppStrings.invalidEmail;
    }

    if (password.isEmpty) {
      errors['password'] = AppStrings.passwordRequired;
    }

    if (errors.isNotEmpty) return AuthResult.failure(errors);

    try {
      final user = await _repository.signIn(email: email, password: password);
      if (user != null) {
        return AuthResult.success();
      } else {
        return AuthResult.failure({'email': 'Login failed. Please try again.'});
      }
    } catch (e) {
      return AuthResult.failure({'email': e.toString()});
    }
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$').hasMatch(value);
}
