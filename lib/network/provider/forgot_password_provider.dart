import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/base_response.dart';
import 'package:chat_app/network/response/forgot_password_response.dart';
import 'package:dio/dio.dart';

import '../api/api_path.dart';

class ForgotPasswordProvider with ProviderMixin {
  Future<ForgotPasswordResponse> fogotPassword({
    required String? email,
  }) async {
    try {
      final response = await dio.post(
        ApiPath.forgotPassword,
        data: {"email": email},
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          receiveDataWhenStatusError: true,
        ),
      );
      return ForgotPasswordResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.forgotPassword);
      return ForgotPasswordResponse();
    }

  }
}
