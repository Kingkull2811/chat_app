import 'dart:io';

class BaseResponse {
  int? httpStatus;
  dynamic errors;

  BaseResponse({this.httpStatus, this.errors});

  BaseResponse.withHttpError({
    this.errors,
    this.httpStatus,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        httpStatus: json["httpStatus"],
        errors: json["errors"],
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
