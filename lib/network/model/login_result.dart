import 'package:chat_app/network/response/error_response.dart';

class LoginResult {
  final bool isSuccess;
  final LoginError error;
  final List<Errors>? errors;

  LoginResult({
    this.isSuccess =false,
    this.error = LoginError.unknown,
    this.errors,
});

  @override
  String toString() {
    return 'LoginResult{isSuccess: $isSuccess, error: $errors}';
  }
}

enum LoginError {
  incorrectLogin,
  internalServerError,
  emptyAuthorizationCode,
  unknown,
}
