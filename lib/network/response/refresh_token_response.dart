import 'package:chat_app/network/model/error.dart';
import 'package:chat_app/network/model/refresh_token_model.dart';
import 'package:chat_app/network/response/base_response.dart';

class RefreshTokenResponse extends BaseResponse {
  final RefreshTokenModel? data;

  RefreshTokenResponse({
    int? httpStatus,
    String? message,
    List<Errors>? errors,
    this.data,
  }) : super(httpStatus: httpStatus, message: message, errors: errors);

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> listError = json["errors"] ?? [];
    List<Errors> errors = listError.map((e) => Errors.fromJson(e)).toList();

    return RefreshTokenResponse(
      httpStatus: json["httpStatus"],
      message: json["message"],
      errors: errors,
      data: RefreshTokenModel.fromJson(json["data"]),
    );
  }

  @override
  String toString() {
    return 'RefreshTokenResponse{httpStatus: $httpStatus, message: $message, errors: $errors, data: $data}';
  }
}
