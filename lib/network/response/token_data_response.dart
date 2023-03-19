class TokenDataResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? expiredAccessToken;

  TokenDataResponse({
     this.accessToken,
     this.refreshToken,
     this.expiredAccessToken,
  });

  factory TokenDataResponse.fromJson(Map<String, dynamic> json) {
    return TokenDataResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiredAccessToken: json['expiredAccessDate'],
    );
  }
}