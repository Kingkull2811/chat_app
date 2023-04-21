import '../model/user_info_model.dart';
import 'base_get_response.dart';

class GetUserInfoResponse extends BaseGetResponse {
  final UserInfoModel userData;

  GetUserInfoResponse({
    required this.userData,
    int? pageNumber,
    int? pageSize,
    int? totalRecord,
    int? status,
    String? error,
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          totalRecord: totalRecord,
          status: status,
          error: error,
        );

  factory GetUserInfoResponse.fromJson(Map<String, dynamic> json) {
    return GetUserInfoResponse(
      userData: json[''],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecord: json['totalRecord'],
      status: json['status'],
      error: json['error'],
    );
  }
}
