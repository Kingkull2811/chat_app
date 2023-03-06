import 'base_response.dart';

class LoginResponse extends BaseResponse {
  final String? path;
  final String? message;

  LoginResponse({
    status,
    error,
    this.path,
    this.message,
  }) : super(status: status, errors: error);

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        path: json["path"],
        error: json["path"],
        message: json["path"],
        status: json["path"],
      );
}

class ErrorResponse {
  final int httpStatus;
  final List<Error> errors;

  ErrorResponse({required this.httpStatus, required this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    final errorsList = json['errors'] as List<dynamic>;
    final errors = errorsList.map((e) => Error.fromJson(e)).toList();

    return ErrorResponse(
      httpStatus: json['httpStatus'] as int,
      errors: errors,
    );
  }
}

class Error {
  final String errorCode;
  final String errorMessage;
  final dynamic stackFrames;

  Error({required this.errorCode, required this.errorMessage, required this.stackFrames});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      errorCode: json['errorCode'] as String,
      errorMessage: json['errorMessage'] as String,
      stackFrames: json['stackFrames'],
    );
  }
}

