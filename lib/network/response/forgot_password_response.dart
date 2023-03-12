import 'package:chat_app/network/response/base_response.dart';

import 'error_response.dart';

class ForgotPasswordResponse extends BaseResponse{
  ForgotPasswordResponse({
    int? httpStatus,
    Errors? errors,
}): super(httpStatus:httpStatus, errors: errors);
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json)=>ForgotPasswordResponse(
    httpStatus: json["httpStatus"],
    errors: json["errors"],
  );
}