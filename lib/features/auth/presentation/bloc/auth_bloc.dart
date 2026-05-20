import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/auth/domain/repositories/auth_repository.dart';
import 'package:news_ui_kit/features/auth/domain/repositories/user_repository.dart';
import 'package:news_ui_kit/features/auth/domain/use_cases/login_use_case.dart';
import 'package:news_ui_kit/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:news_ui_kit/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:news_ui_kit/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:news_ui_kit/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final AuthRepository _repository;
  final UserRepository _userRepository;

  AuthBloc(AuthRepository repository, UserRepository userRepository)
      : _repository = repository,
        _userRepository = userRepository,
        _loginUseCase = LoginUseCase(repository),
        _signupUseCase = SignupUseCase(repository, userRepository),
        _forgotPasswordUseCase = ForgotPasswordUseCase(repository),
        _verifyOtpUseCase = VerifyOtpUseCase(),
        _resetPasswordUseCase = ResetPasswordUseCase(repository),
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
      // After login success, check if user has a profile in Firestore
      final firebaseUser = _repository.currentUser;
      bool hasProfile = false;
      if (firebaseUser != null) {
        hasProfile = await _userRepository.profileExists(firebaseUser.uid);
      }
      
      emit(state.copyWith(
        errors: {}, 
        isLoading: false, 
        isSuccess: true,
        hasProfile: hasProfile,
      ));
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
      event.email,
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
  Future<void> _onOtpSubmitted(OtpSubmitted event, Emitter<AuthState> emit) async {
    final result = await _verifyOtpUseCase(event.otpDigits.join());

    if (result.isSuccess) {
      emit(state.copyWith(errors: {}, isSuccess: true));
    } else {
      emit(state.copyWith(errors: result.errors, isSuccess: false));
    }
  }

  // ── Reset Password ──
  Future<void> _onResetPasswordSubmitted(
      ResetPasswordSubmitted event, Emitter<AuthState> emit) async {
    final result = await _resetPasswordUseCase(
      code: event.confirmPassword, // Temporary: mapping 'code' to whatever the UI has
      newPassword: event.newPassword,
    );

    if (result.isSuccess) {
      emit(state.copyWith(errors: {}, isSuccess: true));
    } else {
      emit(state.copyWith(errors: result.errors, isSuccess: false));
    }
  }
}
