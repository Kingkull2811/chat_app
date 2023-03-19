
class UserInfoResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? id;
  final String? username;
  final String? email;
  final String? roles;
  final String? expiredAccessToken;
  final String? expiredRefreshToken;

  UserInfoResponse({
    this.accessToken,
    this.refreshToken,
    this.id,
    this.username,
    this.email,
    this.roles,
    this.expiredAccessToken,
    this.expiredRefreshToken,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) => UserInfoResponse(
    accessToken: json['accessToken'],
    refreshToken: json['refreshToken'],
    id: json['id'],
    username: json['username'],
    email: json['email'],
    roles: json['roles'],
    expiredAccessToken: json['expiredAccessDate'],
    expiredRefreshToken: json['expiredRefreshDate'],
  );

  @override
  String toString() {
    return 'UserInfoResponse{accessToken: $accessToken, refreshToken: $refreshToken, id: $id, username: $username, email: $email, roles: $roles, expiredAccessToken: $expiredAccessToken, expiredRefreshToken: $expiredRefreshToken}';
  }
}
