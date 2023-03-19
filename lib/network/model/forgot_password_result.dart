import 'package:chat_app/network/response/error_response.dart';

class ForgotPasswordResult {
  final bool isSuccess;
  List<Errors>? errors;

  ForgotPasswordResult({
    this.isSuccess =false,
    this.errors,
});

  @override
  String toString() {
    return 'ForgotPasswordResult{isSuccess: $isSuccess, error: $errors}';
  }
}
