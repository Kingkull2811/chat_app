class LoginResult {
  final bool isSuccess;
  LoginError error;

  LoginResult({
    this.isSuccess =false,
    this.error = LoginError.unknown,
});

  @override
  String toString() {
    return 'LoginResult{isSuccess: $isSuccess, error: $error}';
  }
}

enum LoginError {
  incorrectLogin,
  internalServerError,
  emptyAuthorizationCode,
  unknown,
}
