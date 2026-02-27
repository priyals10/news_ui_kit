import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// ── Login ──
class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  const LoginSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

// ── Signup ──
class SignupSubmitted extends AuthEvent {
  final String username;
  final String password;
  final String confirmPassword;

  const SignupSubmitted({
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [username, password, confirmPassword];
}

// ── Forgot Password ──
class ForgotPasswordSubmitted extends AuthEvent {
  final String emailOrMobile;

  const ForgotPasswordSubmitted({required this.emailOrMobile});

  @override
  List<Object?> get props => [emailOrMobile];
}

// ── OTP ──
class OtpSubmitted extends AuthEvent {
  final List<String> otpDigits;

  const OtpSubmitted({required this.otpDigits});

  @override
  List<Object?> get props => [otpDigits];
}

// ── Reset Password ──
class ResetPasswordSubmitted extends AuthEvent {
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordSubmitted({
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [newPassword, confirmPassword];
}
