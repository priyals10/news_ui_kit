import 'auth_result.dart';

class VerifyOtpUseCase {
  VerifyOtpUseCase();

  /// Placeholder for OTP verification logic.
  Future<AuthResult> call(String otp) async {
    if (otp.length == 6) {
      return AuthResult.success();
    }
    return AuthResult.failure({'otp': 'Invalid OTP code'});
  }
}
