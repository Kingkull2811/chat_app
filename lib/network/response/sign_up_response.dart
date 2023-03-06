import 'package:chat_app/network/response/base_response.dart';

class SignUpResponse extends BaseResponse {
  final String? message;
  final int? id;
  final dynamic type;
  final String? accessToken;
  final String? refreshToken;
  final String? username;
  final String? email;
  final String? roles;

  SignUpResponse({
    status,
    errors,
    this.id,
    this.type,
    this.accessToken,
    this.refreshToken,
    this.username,
    this.email,
    this.roles,
    this.message,
  }) : super(status: status, errors: errors);

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
        status: json["status"],
        errors: json["errors"],
        id: json["id"],
        type: json["type"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        email: json["email"],
        username: json["username"],
        roles: json["roles"],
        message: json["message"],
      );
}

// {
// "accessToken": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJyb2xlIjpbeyJhdXRob3JpdHkiOiJST0xFX1VTRVIifV0sImV4cCI6MTY3ODA5NDIyMywidXNlcklkIjoxLCJpYXQiOjE2NzgwOTM2MjMsImVtYWlsIjoidGVzdEBnbWFpbC5jb20iLCJ1c2VybmFtZSI6InRlc3QxIn0.APbKOWdztb6wnuGB15_w9_92rylN3ZA1dTucn3UHcyz1KAWzroK1D0UxgOJuq8fx3XraJxro5T_iDil_FIhBtw",
// "refreshToken": "0de8246a-9e82-4bed-8747-a151000a825e",
// "type": null,
// "id": 1,
// "username": "test1",
// "email": "test@gmail.com",
// "roles": null
// }
