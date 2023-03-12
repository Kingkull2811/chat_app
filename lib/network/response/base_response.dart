import 'dart:io';
import 'error_response.dart';

class BaseResponse {
  int? httpStatus;
  dynamic errors;
  // Errors? errors;
  // String? message;

  BaseResponse({this.httpStatus, this.errors,});

  BaseResponse.withHttpError({
    this.errors,
    this.httpStatus,
//    this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        httpStatus: json["httpStatus"],
        errors: json["errors"],
//        message: json["message"],
      );

  bool isOK() {
    return httpStatus == HttpStatus.ok;
  }

  bool isFailure() {
    return httpStatus != HttpStatus.ok;
  }
}

class ExpiredTokenResponse extends BaseResponse {
  ExpiredTokenResponse()
      : super(
          httpStatus: HttpStatus.unauthorized,
          errors: 'Token Expired !',
        );
}
