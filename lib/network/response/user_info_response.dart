class UserInfoResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? id;
  final String? username;
  final String? email;
  final String? phone;
  final String? fullName;
  final List<String>? roles;
  final String? expiredAccessToken;
  final String? expiredRefreshToken;
  final bool isFillProfileKey;

  UserInfoResponse({
    this.accessToken,
    this.refreshToken,
    this.id,
    this.username,
    this.email,
    this.phone,
    this.fullName,
    this.roles,
    this.expiredAccessToken,
    this.expiredRefreshToken,
    this.isFillProfileKey = false,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      UserInfoResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        id: json['id'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
        fullName: json['fullName'],
        roles: List<String>.from(json['roles']),
        expiredAccessToken: json['expiredAccessDate'],
        expiredRefreshToken: json['expiredRefreshDate'],
        isFillProfileKey: json['isFillProfileKey'] ?? false,
      );

  @override
  String toString() {
    return 'UserInfoResponse{accessToken: $accessToken, refreshToken: $refreshToken, id: $id, username: $username, email: $email, roles: $roles, expiredAccessToken: $expiredAccessToken, expiredRefreshToken: $expiredRefreshToken, isFillProfileKey: $isFillProfileKey}';
  }
}
