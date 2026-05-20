import '../repositories/auth_repository.dart';
import 'auth_result.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<AuthResult> call({required String code, required String newPassword}) async {
    try {
      await _repository.confirmPasswordReset(code: code, newPassword: newPassword);
      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure({'password': e.toString()});
    }
  }
}
