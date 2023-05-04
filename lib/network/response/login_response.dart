import 'package:chat_app/network/model/error.dart';
import 'package:chat_app/network/response/user_info_response.dart';
import 'package:chat_app/utilities/utils.dart';

import 'base_response.dart';

class LoginResponse extends BaseResponse {
  final UserInfoResponse? data;

  LoginResponse({
    int? httpStatus,
    String? message,
    List<Errors>? errors,
    this.data,
  }) : super(
          httpStatus: httpStatus,
          message: message,
          errors: errors,
        );

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    List<Errors> errors = [];
    if(isNotNullOrEmpty(json["errors"])){
      final List<dynamic> errorsJson = json["errors"];
      errors = errorsJson.map((errorJson) => Errors.fromJson(errorJson)).toList();
    }
    return LoginResponse(
      httpStatus: json["httpStatus"],
      message: json["message"],
      errors: errors,
      data: json["data"] == null ? null : UserInfoResponse.fromJson(json["data"]),
    );
  }

  @override
  String toString() {
    return 'LoginResponse{httpStatus: $httpStatus, message: $message, errors: $errors, data: $data}';
  }
}
