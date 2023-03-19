import 'package:chat_app/network/response/error_data_response.dart';
import 'package:chat_app/network/response/user_info_response.dart';

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
    return LoginResponse(
      httpStatus: json["httpStatus"],
      message: json["message"],
      errors: json["errors"],
      data: UserInfoResponse.fromJson(json["data"]),
    );
  }

  @override
  String toString() {
    return 'LoginResponse{httpStatus: $httpStatus, message: $message, errors: $errors, data: $data}';
  }
}
