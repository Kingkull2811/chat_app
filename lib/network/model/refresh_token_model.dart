class RefreshTokenModel {
  final String? accessToken;
  final String? refreshToken;
  final String? expiredAccessToken;

  RefreshTokenModel({
    this.accessToken,
    this.refreshToken,
    this.expiredAccessToken,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiredAccessToken: json['expiredAccessDate'],
    );
  }

  @override
  String toString() {
    return 'RefreshTokenModel{accessToken: $accessToken, refreshToken: $refreshToken, expiredAccessToken: $expiredAccessToken}';
  }
}
