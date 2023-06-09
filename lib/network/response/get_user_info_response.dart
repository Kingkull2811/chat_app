import '../../utilities/utils.dart';
import '../model/error.dart';
import '../model/user_info_model.dart';
import 'base_response.dart';

class GetUserInfoResponse extends BaseResponse {
  final UserInfoModel userData;

  GetUserInfoResponse({
    int? httpStatus,
    String? message,
    List<Errors>? errors,
    required this.userData,
  }) : super(
          httpStatus: httpStatus,
          message: message,
          errors: errors,
        );

  factory GetUserInfoResponse.fromJson(Map<String, dynamic> json) {
    List<Errors> errors = [];
    if (isNotNullOrEmpty(json["errors"])) {
      final List<dynamic> errorsJson = json["errors"];
      errors =
          errorsJson.map((errorJson) => Errors.fromJson(errorJson)).toList();
    }
    return GetUserInfoResponse(
      httpStatus: json["httpStatus"],
      message: json["message"],
      errors: errors,
      userData: UserInfoModel.fromJson(json[""]),
    );
  }

  @override
  String toString() {
    return 'GetUserInfoResponse{userData: $userData}';
  }
}
