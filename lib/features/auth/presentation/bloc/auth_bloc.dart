import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'package:news_ui_kit/features/auth/use_cases/login_use_case.dart';
import 'package:news_ui_kit/features/auth/use_cases/signup_use_case.dart';
import 'package:news_ui_kit/features/auth/use_cases/forgot_password_use_case.dart';
import 'package:news_ui_kit/features/auth/use_cases/verify_otp_use_case.dart';
import 'package:news_ui_kit/features/auth/use_cases/reset_password_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase = VerifyOtpUseCase();
  final ResetPasswordUseCase _resetPasswordUseCase = ResetPasswordUseCase();
  final AuthRepository _repository;

  AuthBloc(AuthRepository repository)
      : _repository = repository,
        _loginUseCase = LoginUseCase(repository),
        _signupUseCase = SignupUseCase(repository),
        _forgotPasswordUseCase = ForgotPasswordUseCase(repository),
        super(AuthState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    // Show loading and reset success flag so navigation listener can fire correctly
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await _repository.signOut();
      emit(AuthState.initial().copyWith(isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isSuccess: false));
    }
  }

  // ── Login ──
  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, errors: {}, isSuccess: false));

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    if (result.isSuccess) {
      emit(state.copyWith(errors: {}, isLoading: false, isSuccess: true));
    } else {
      emit(state.copyWith(
          errors: result.errors, isLoading: false, isSuccess: false));
    }
  }

  // ── Signup ──
  Future<void> _onSignupSubmitted(
      SignupSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, errors: {}, isSuccess: false));

    final result = await _signupUseCase(
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );

    if (result.isSuccess) {
      emit(state.copyWith(errors: {}, isLoading: false, isSuccess: true));
    } else {
      emit(state.copyWith(
          errors: result.errors, isLoading: false, isSuccess: false));
    }
  }

  // ── Forgot Password ──
  Future<void> _onForgotPasswordSubmitted(
      ForgotPasswordSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, errors: {}, isSuccess: false));

    final result = await _forgotPasswordUseCase(
      email: event.email,
    );

    if (result.isSuccess) {
      emit(state.copyWith(
        errors: {},
        isLoading: false,
        isSuccess: true,
        validatedContact: result.data,
      ));
    } else {
      emit(state.copyWith(
          errors: result.errors, isLoading: false, isSuccess: false));
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
