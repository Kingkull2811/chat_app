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
    try {
      final response = await dio.post(
        ApiPath.login,
        //data: {"password": password, "username": username},
         data: {"password": "123456", "username": "truongtran"},
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          receiveDataWhenStatusError: true,
        ),
      );

      return LoginResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.login);
      return LoginResponse();
    }
  }

  Future<AuthTokens> getTokenByRefreshToken({
    required String refreshToken,
  }) async {
    // try {
    //   Map<String, dynamic> body = {'refreshToken': 'Bearer $refreshToken'};
    //   Options options = Options(headers: body);
    //   Response response = await _dio.get(ApiPath.refreshToken, options: options);
    //   return AuthTokens.fromJson(response.data);
    // } catch (error, stacktrace) {
    //  // showErrorLog(error, stacktrace, ApiPath.refreshToken);
    return AuthTokens();
    // }
  }
}
