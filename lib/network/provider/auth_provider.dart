import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/model/refresh_token_model.dart';
import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/services/notification_services.dart';
import 'package:chat_app/utilities/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../utilities/shared_preferences_storage.dart';
import '../response/base_get_response.dart';
import '../response/base_response.dart';
import '../response/login_response.dart';

class AuthProvider with ProviderMixin {
  final SharedPreferencesStorage _pref = SharedPreferencesStorage();

  Future<bool> checkAuthenticationStatus() async {
    String accessTokenExpired = _pref.getAccessTokenExpired();

    if (DateTime.parse(accessTokenExpired).isBefore(DateTime.now())) {
      String refreshTokenExpired = _pref.getRefreshTokenExpired();

      if (DateTime.parse(refreshTokenExpired).isAfter(DateTime.now())) {
        String refreshToken = await SecureStorage().getRefreshToken();

        final response = await AuthProvider().refreshToken(
          refreshToken: refreshToken,
        );
        await _pref.saveInfoWhenRefreshToken(data: response);
        return true;
      }
      return false;
    }
    return true;
  }

  Future<RefreshTokenModel?> refreshToken({
    required String refreshToken,
  }) async {
    try {
      Response response = await dio.post(
        ApiPath.refreshToken,
        data: {"refreshToken": refreshToken},
      );
      return RefreshTokenModel.fromJson(response.data['data']);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.refreshToken);
      return null;
    }
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiPath.login,
        data: {
          "deviceToken": await FirebaseMessagingServices().getDeviceToken(),
          "password": password,
          "username": username,
        },
      );

      return LoginResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.login);
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

      return BaseResponse.fromJson(response.data);
    } catch (error) {
      // return errorResponse(error, stacktrace, ApiPath.signup);
      return BaseResponse();
    }
  }

  Future<Object> getUserInfo({required int userId}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenResponse();
    }
    final String apiGetProfile = join(ApiPath.fillProfile, userId.toString());

    try {
      final response = await dio.get(
        apiGetProfile,
        options: await defaultOptions(url: apiGetProfile),
      );

      return UserInfoModel.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, apiGetProfile);
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
