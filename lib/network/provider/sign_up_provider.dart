import 'dart:developer';

import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:dio/dio.dart';

import '../api/api_path.dart';
import '../response/sign_up_response.dart';

class SignUpProvider with ProviderMixin {
  Future<SignUpResponse> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final data = {
        "email": email,
        "password": password,
        "username": username,
      };
      final response = await dio.post(
        ApiPath.signup,
        data: data,
        options: AppConstants.options,
      );
      return SignUpResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      //showErrorLog(error, stacktrace, ApiPath.signup);
      if(error is DioError){
        return SignUpResponse.fromJson(error.response?.data);
      }
      return SignUpResponse();
    }
  }
}
