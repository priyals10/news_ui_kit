class AuthResult {
  final bool isSuccess;
  final Map<String, String> errors;
  final String? data;

  const AuthResult({
    required this.isSuccess,
    this.errors = const {},
    this.data,
  });

  factory AuthResult.success({String? data}) =>
      AuthResult(isSuccess: true, data: data);

  factory AuthResult.failure(Map<String, String> errors) =>
      AuthResult(isSuccess: false, errors: errors);
}
