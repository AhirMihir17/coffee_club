class ForgotPasswordResponse {
  const ForgotPasswordResponse.success()
    : isSuccess = true,
      errorMessage = null;

  const ForgotPasswordResponse.failure(String message)
    : isSuccess = false,
      errorMessage = message;

  final bool isSuccess;
  final String? errorMessage;
}
