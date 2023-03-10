import 'base_response.dart';

class LoginResponse extends BaseResponse {
  final String? message;
  final LoginData? data;

  LoginResponse({
    int? httpStatus,
    this.message,
    this.data,
  }) : super(httpStatus: httpStatus, errors: message);

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      httpStatus: json['httpStatus'],
      message: json['message'],
      data: LoginData.fromJson(json["data"]),
    );
  }
}

class LoginData {
  final String? accessToken;
  final String? refreshToken;
  final int? id;
  final String? username;
  final String? email;
  final String? roles;

  LoginData({
    this.accessToken,
    this.refreshToken,
    this.id,
    this.username,
    this.email,
    this.roles,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        id: json['id'],
        username: json['username'],
        email: json['email'],
        roles: json['roles'],
      );

  @override
  String toString() {
    return 'LoginData{accessToken: $accessToken, refreshToken: $refreshToken, id: $id, username: $username, email: $email, roles: $roles}';
  }
}
