import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/auth/use_cases/login_use_case.dart';
import 'package:news_ui_kit/features/auth/use_cases/signup_use_case.dart';
import 'package:news_ui_kit/features/auth/use_cases/forgot_password_use_case.dart';
import 'package:news_ui_kit/features/auth/use_cases/verify_otp_use_case.dart';
import 'package:news_ui_kit/features/auth/use_cases/reset_password_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase = LoginUseCase();
  final SignupUseCase _signupUseCase = SignupUseCase();
  final ForgotPasswordUseCase _forgotPasswordUseCase = ForgotPasswordUseCase();
  final VerifyOtpUseCase _verifyOtpUseCase = VerifyOtpUseCase();
  final ResetPasswordUseCase _resetPasswordUseCase = ResetPasswordUseCase();

  AuthBloc() : super(AuthState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  // ── Login ──
  void _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) {
    final result = _loginUseCase(
      username: event.username,
      password: event.password,
    );

    if (result.isSuccess) {
      emit(state.copyWith(errors: {}, isSuccess: true));
    } else {
      emit(state.copyWith(errors: result.errors, isSuccess: false));
    }
  }

  // ── Signup ──
  void _onSignupSubmitted(SignupSubmitted event, Emitter<AuthState> emit) {
    final result = _signupUseCase(
      username: event.username,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );

    if (result.isSuccess) {
      emit(state.copyWith(errors: {}, isSuccess: true));
    } else {
      emit(state.copyWith(errors: result.errors, isSuccess: false));
    }
  }

  // ── Forgot Password ──
  void _onForgotPasswordSubmitted(
      ForgotPasswordSubmitted event, Emitter<AuthState> emit) {
    final result = _forgotPasswordUseCase(
      emailOrMobile: event.emailOrMobile,
    );

    if (result.isSuccess) {
      emit(state.copyWith(
        errors: {},
        isSuccess: true,
        validatedContact: result.data,
      ));
    } else {
      emit(state.copyWith(errors: result.errors, isSuccess: false));
    }
  }

  // ── OTP ──
  void _onOtpSubmitted(OtpSubmitted event, Emitter<AuthState> emit) {
    final result = _verifyOtpUseCase(otpDigits: event.otpDigits);

    if (result.isSuccess) {
      emit(state.copyWith(errors: {}, isSuccess: true));
    } else {
      emit(state.copyWith(errors: result.errors, isSuccess: false));
    }
  }

  // ── Reset Password ──
  void _onResetPasswordSubmitted(
      ResetPasswordSubmitted event, Emitter<AuthState> emit) {
    final result = _resetPasswordUseCase(
      newPassword: event.newPassword,
      confirmPassword: event.confirmPassword,
    );

    if (result.isSuccess) {
      emit(state.copyWith(errors: {}, isSuccess: true));
    } else {
      emit(state.copyWith(errors: result.errors, isSuccess: false));
    }
  }
}
