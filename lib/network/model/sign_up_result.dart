import 'package:chat_app/network/response/error_response.dart';

class SignUpResult{
  final bool isSuccess;
  final String? message;
  final List<Errors>? errors;

  SignUpResult({ this.isSuccess = false, this.message, this.errors});

  @override
  String toString() {
    return 'SignUpResult{isSuccess: $isSuccess, message: $message, errors: $errors}';
  }
}
