class AuthTokens {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;

  AuthTokens({
     this.accessToken,
     this.refreshToken,
     this.tokenType,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      tokenType: json['tokenType'],
    );
  }
}