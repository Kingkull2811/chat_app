import 'package:chat_app/network/response/base_response.dart';

import 'error_response.dart';

class SignUpResponse extends BaseResponse {

  final String? message;
  final List<Errors>? error;

  SignUpResponse({
    httpStatus,
    this.message,
    this.error,
  }) : super(httpStatus: httpStatus, errors: message);

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic>? errorsJson = json['errors'];
    List<Errors>? error;
    if (errorsJson != null) {
      error = [];
      for (var errorJson in errorsJson) {
        error.add(Errors.fromJson(errorJson));
      }
    }
    return SignUpResponse(
      httpStatus: json['httpStatus'],
      message: json['message'],
      error: error,
    );
  }
}

