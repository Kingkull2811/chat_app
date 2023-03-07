import 'package:chat_app/network/response/base_response.dart';

class SignUpResponse extends BaseResponse {

  final String? message;
  final List<SignUpError>? error;

  SignUpResponse({
    httpStatus,
    this.message,
    this.error,
  }) : super(httpStatus: httpStatus, errors: message);

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic>? errorsJson = json['errors'];
    List<SignUpError>? error;
    if (errorsJson != null) {
      error = [];
      for (var errorJson in errorsJson) {
        error.add(SignUpError.fromJson(errorJson));
      }
    }
    return SignUpResponse(
      httpStatus: json['httpStatus'],
      message: json['message'],
      error: error,
    );
  }
}

class SignUpError {
  final String? errorCode;
  final String? errorMessage;
  final dynamic stackFrames;

  SignUpError({
    this.errorCode,
    this.errorMessage,
    this.stackFrames,
  });

  factory SignUpError.fromJson(Map<String, dynamic> json) => SignUpError(
        errorCode: json['errorCode'],
        errorMessage: json['errorMessage'],
        stackFrames: json['stackFrames'],
      );
}
