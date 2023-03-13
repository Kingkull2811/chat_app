import 'package:chat_app/network/response/base_response.dart';

import 'error_response.dart';

class SignUpResponse extends BaseResponse {
  final String? message;

  SignUpResponse({
    httpStatus,
    this.message,
    List<Errors>? errors,
  }) : super(httpStatus: httpStatus, errors: errors);

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    // List<dynamic>? errorsJson = json['errors'];
    // List<Errors>? error;
    // if (errorsJson != null) {
    //   error = [];
    //   for (var errorJson in errorsJson) {
    //     error.add(Errors.fromJson(errorJson));
    //   }
    // }
    return SignUpResponse(
      httpStatus: json['httpStatus'],
      message: json['message'],
      errors: json['errors'],
    );
  }

  @override
  String toString() {
    return 'SignUpResponse{message: $message, error: $errors}';
  }
}

