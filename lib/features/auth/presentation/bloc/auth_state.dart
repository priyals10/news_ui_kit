import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  // Field-level errors (key = field name, value = error message)
  final Map<String, String?> errors;

  // Status flags
  final bool isLoading;
  final bool isSuccess;

  // For forgot password → pass validated contact to OTP screen
  final String? validatedContact;

  // For login/signup flow redirection
  final bool hasProfile;

  const AuthState({
    this.errors = const {},
    this.isLoading = false,
    this.isSuccess = false,
    this.validatedContact,
    this.hasProfile = false,
  });

  // Initial state
  factory AuthState.initial() => const AuthState();

  // Copy helper
  AuthState copyWith({
    Map<String, String?>? errors,
    bool? isLoading,
    bool? isSuccess,
    String? validatedContact,
    bool? hasProfile,
  }) {
    return AuthState(
      errors: errors ?? this.errors,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      validatedContact: validatedContact ?? this.validatedContact,
      hasProfile: hasProfile ?? this.hasProfile,
    );
  }

  // Quick accessors for each field error
  String? get usernameError => errors['username'];
  String? get passwordError => errors['password'];
  String? get confirmPasswordError => errors['confirmPassword'];
  String? get emailError => errors['email'];
  String? get otpError => errors['otp'];
  String? get newPasswordError => errors['newPassword'];

  @override
  List<Object?> get props => [errors, isLoading, isSuccess, validatedContact, hasProfile];
}
