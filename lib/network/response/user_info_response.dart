class UserInfoResponse {
  final String accessToken;
  final String refreshToken;
  final int id;
  final String username;
  final String email;
  final String phone;
  final String fullName;
  final List<String>? roles;
  final String expiredAccessToken;
  final String expiredRefreshToken;
  final bool isFillProfileKey;

  UserInfoResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.fullName,
    this.roles,
    required this.expiredAccessToken,
    required this.expiredRefreshToken,
    this.isFillProfileKey = false,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      UserInfoResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        id: json['id'] as int,
        username: json['username'] as String,
        email: json['email'] as String,
        phone: json['phone'] == null ? '' : (json['phone'] as String),
        fullName: json['fullName'] == null ? '' : json['fullName'] as String,
        roles: List<String>.from(json['roles']),
        expiredAccessToken: json['expiredAccessDate'] as String,
        expiredRefreshToken: json['expiredRefreshDate'] as String,
        isFillProfileKey: json['isFillProfileKey'] ?? false,
      );

  @override
  String toString() {
    return 'UserInfoResponse{accessToken: $accessToken, refreshToken: $refreshToken, id: $id, username: $username, email: $email, roles: $roles, expiredAccessToken: $expiredAccessToken, expiredRefreshToken: $expiredRefreshToken, isFillProfileKey: $isFillProfileKey}';
  }
}
