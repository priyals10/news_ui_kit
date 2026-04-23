import 'package:news_ui_kit/core/constants/app_strings.dart';
import '../repositories/auth_repository.dart';
import 'auth_result.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<AuthResult> call(String email) async {
    if (email.isEmpty) {
      return AuthResult.failure({'email': AppStrings.emailRequired});
    }
    if (!_isValidEmail(email)) {
      return AuthResult.failure({'email': AppStrings.invalidEmail});
    }

    try {
      await _repository.sendPasswordResetEmail(email);
      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure({'email': e.toString()});
    }
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$').hasMatch(value);
}
