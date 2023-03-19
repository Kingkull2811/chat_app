import 'package:chat_app/network/response/error_data_response.dart';

class BaseAuthResult {
  final bool isSuccess;
  final String? message;
  final List<Errors>? errors;

  BaseAuthResult({
    this.isSuccess = false,
    this.message,
    this.errors,
});

  @override
  String toString() {
    return 'ForgotPasswordResult{isSuccess: $isSuccess, message: $message, errors: $errors}';
  }
}
