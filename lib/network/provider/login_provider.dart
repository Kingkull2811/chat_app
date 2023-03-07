import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/auth_token.dart';
import 'package:dio/dio.dart';

import '../response/login_response.dart';

class LoginProvider with ProviderMixin {
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      "password": password,
      "username": username,
    };
    Options options = Options(headers: body);
    try {
      Response response = await dio.get(ApiPath.login, options: options);
      return LoginResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.login);
      return LoginResponse();
    }
  }

  Future<AuthTokens> getTokenByRefreshToken({
    required String refreshToken,
  }) async {
    try {
      Map<String, dynamic> body = {'refreshToken': 'Bearer $refreshToken'};
      Options options = Options(headers: body);
      Response response = await dio.get(ApiPath.refreshToken, options: options);
      return AuthTokens.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.refreshToken);
      return AuthTokens();
    }
  }
}
