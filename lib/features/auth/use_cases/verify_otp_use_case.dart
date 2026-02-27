import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'auth_result.dart';

class VerifyOtpUseCase {
  AuthResult call({required List<String> otpDigits}) {
    final hasEmpty = otpDigits.any((d) => d.isEmpty);

    if (hasEmpty) {
      return AuthResult.failure({'otp': AppStrings.invalidOtp});
    }
    return AuthResult.success();

  }
}
