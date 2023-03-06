import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/model/login_result.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
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
}
