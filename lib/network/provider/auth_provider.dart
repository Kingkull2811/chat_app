import 'dart:developer';

import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/base_response.dart';
import 'package:chat_app/network/response/refresh_token_response.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/secure_storage.dart';
import 'package:dio/dio.dart';

import '../../utilities/shared_preferences_storage.dart';
import '../response/base_get_response.dart';
import '../response/login_response.dart';

class AuthProvider with ProviderMixin {
  final SecureStorage _secureStorage = SecureStorage();

  Future<bool> checkAuthenticationStatus() async {
    String accessTokenExpired =
        SharedPreferencesStorage().getAccessTokenExpired();

    if (DateTime.parse(accessTokenExpired).isBefore(DateTime.now())) {
      String refreshTokenExpired =
          SharedPreferencesStorage().getRefreshTokenExpired();

      if (DateTime.parse(refreshTokenExpired).isAfter(DateTime.now())) {
        String refreshToken = await _secureStorage.readSecureData(
          AppConstants.refreshTokenKey,
        );

        final response = await AuthProvider().refreshToken(
          refreshToken: refreshToken,
        );
        await SharedPreferencesStorage().saveInfoWhenRefreshToken(
          refreshTokenData: response.data,
        );
        return true;
      }
      return false;
    }
    return true;
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
      // log("new token data: ${response.data.toString()}");

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
        // options: AppConstants.options,
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
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post(
        ApiPath.signup,
        data: data,
        options: baseOption(),
      );
      log('signUp: $response');

      return BaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return BaseResponse.fromJson(error.response?.data);
      }
      // return errorResponse(error, stacktrace, ApiPath.signup);
      return BaseResponse();
    }
  }

  Future<Object> getUserInfo({
    required int userId,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    final String apiGetProfile = ApiPath.fillProfile + userId.toString();

    try {
      final response = await dio.get(
        apiGetProfile,
        options: await defaultOptions(url: apiGetProfile),
      );
      // log(response.toString());

      return UserInfoModel.fromJson(response.data);
    } catch (error, stacktrace) {
      log(error.toString(), stackTrace: stacktrace);
      return UserInfoModel();
    }
  }

  Future<Object> fillProfile({
    required int userID,
    required Map<String, dynamic> data,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }

    final String apiFillProfile = ApiPath.fillProfile + userID.toString();

    try {
      final response = await dio.put(
        apiFillProfile,
        data: data,
        options: await defaultOptions(url: apiFillProfile),
      );
      // log(response.toString());

      return UserInfoModel.fromJson(response.data);
    } catch (error) {
      return UserInfoModel();
    }
  }

  Future<Object> changePassword(Object data) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.changePassword,
        data: data,
        options: await defaultOptions(url: ApiPath.changePassword),
      );
      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, ApiPath.changePassword);
    }
  }

  Future<BaseResponse> forgotPassword({
    required String? email,
  }) async {
    try {
      final response = await dio.post(
        ApiPath.forgotPassword,
        data: {"email": email},
        options: baseOption(),
      );
      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
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
