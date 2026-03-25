import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// ── Login ──
class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// ── Signup ──
class SignupSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const SignupSubmitted({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, password, confirmPassword];
}

// ── Forgot Password ──
class ForgotPasswordSubmitted extends AuthEvent {
  final String email;

  const ForgotPasswordSubmitted({required this.email});

  @override
  List<Object?> get props => [email];
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

// ── Logout ──
class LogoutRequested extends AuthEvent {}
