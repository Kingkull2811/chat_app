import 'dart:developer';

import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/base_response.dart';
import 'package:chat_app/network/response/refresh_token_response.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../response/login_response.dart';

class AuthProvider with ProviderMixin {
  final SecureStorage _secureStorage = SecureStorage();

  Future<bool> checkAuthenticationStatus() async {
    //   String token =
    //       await _secureStorage.readSecureData(AppConstants.accessTokenKey);
    //   try {
    //     DateTime expirationDate = JwtDecoder.getExpirationDate(token);
    //
    //     if (expirationDate.isBefore(DateTime.now())) {
    //       String refreshToken =
    //           await _secureStorage.readSecureData(AppConstants.refreshTokenKey);
    //       final response = await _loginProvider.getTokenByRefreshToken(
    //         refreshToken: refreshToken,
    //       );
    //       if (response.accessToken != null && response.accessToken != null) {
    //         await saveTokenInfo(
    //           newToken: response.accessToken!,
    //           refreshToken: response.refreshToken!,
    //         );
    //       } else {
    //         return false;
    //       }
    //     }
    //     return true;
    //   } catch (error, stacktrace) {
    //     showErrorLog(error, stacktrace, ApiPath.login);
    //   }
    return false;
  }

  Future<RefreshTokenResponse> refreshToken({
    required String refreshToken,
  }) async {
    try {
      Response response = await dio.post(
        ApiPath.refreshToken,
        data: {"refreshToken": refreshToken},
        // options: AppConstants.options,
      );

      log("new token data: ${response.data.toString()}");

      return RefreshTokenResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.refreshToken);
      if (error is DioError) {
        return RefreshTokenResponse.fromJson(error.response?.data);
      }
      return RefreshTokenResponse();
      // return errorResponse(error, stacktrace, ApiPath.refreshToken);
    }
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiPath.login,
        data: {"password": password, "username": username},
        options: AppConstants.options,
      );

      return LoginResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.login);
      if (error is DioError) {

        return LoginResponse.fromJson(error.response?.data);
      }
      return LoginResponse();
    }
  }

  Future<BaseResponse> signUp({
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
      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // showErrorLog(error, stacktrace, ApiPath.signup);
      // if (error is DioError) {
      //   return BaseResponse.fromJson(error.response?.data);
      // }
      // return BaseResponse();
      return errorResponse(error, stacktrace, ApiPath.forgotPassword);
    }
  }

  Future<BaseResponse> forgotPassword({
    required String? email,
  }) async {
    try {
      final response = await dio.post(
        ApiPath.forgotPassword,
        data: {"email": email},
        //options: AppConstants.options,
      );
      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // showErrorLog(error, stacktrace, ApiPath.forgotPassword);
      // if (error is DioError) {
      //   return BaseResponse.fromJson(error.response?.data);
      // }
      // return BaseResponse();
      return errorResponse(error, stacktrace, ApiPath.forgotPassword);
    }
  }

  Future<BaseResponse> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final data = {"email": email, "otp": otpCode};

      final response = await dio.post(
        ApiPath.sendOtp,
        data: data,
        //options: AppConstants.options,
      );
      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // showErrorLog(error, stacktrace, ApiPath.sendOtp);
      // if (error is DioError) {
      //   return BaseResponse.fromJson(error.response?.data);
      // }
      // return BaseResponse();
      return errorResponse(error, stacktrace, ApiPath.sendOtp);
    }
  }

  Future<BaseResponse> newPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        "confirm_password": confirmPassword,
        "email": email,
        "password": confirmPassword
      };

      final response = await dio.post(
        ApiPath.newPassword,
        data: data,
        //options: AppConstants.options,
      );
      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // showErrorLog(error, stacktrace, ApiPath.newPassword);
      // return BaseResponse();
      return errorResponse(error, stacktrace, ApiPath.newPassword);
    }
  }
}
