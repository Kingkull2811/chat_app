import 'dart:developer';

import 'package:chat_app/network/response/base_get_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../utilities/app_constants.dart';
import '../../utilities/secure_storage.dart';
import '../../utilities/utils.dart';
import '../response/base_response.dart';
import 'auth_provider.dart';

mixin ProviderMixin {
  Dio? _dio;
  AuthProvider? _authenticationProvider;

  Dio get dio {
    if (_dio != null) {
      return _dio!;
    }
    _dio = Dio()..httpClientAdapter = HttpClientAdapter();
    return _dio!;
  }

  void showErrorLog(error, stacktrace, apiPath) {
    if (kDebugMode) {
      if (apiPath != null) {
        print("EXCEPTION OCCURRED: ${apiPath.toString()}");
      }
      if (error is DioError) {
        print("\nEXCEPTION RESPONSE: ${error.response}");
      }
      print("\nEXCEPTION WITH: $error\nSTACKTRACE: $stacktrace");
    } else {
      //record log to firebase crashlytics here}
    }
  }

  BaseResponse errorResponse(error, stacktrace, apiPath) {
    showErrorLog(error, stacktrace, apiPath);

    return BaseResponse.withHttpError(
      errors: (error is DioError) ? error.response?.data : [],
      httpStatus: (error is DioError) ? error.response?.statusCode : null,
    );
  }

  BaseGetResponse errorGetResponse(error, stacktrace, apiPath) {
    showErrorLog(error, stacktrace, apiPath);
    return BaseGetResponse.withHttpError(
      status: error.response?.statusCode,
      error: error.toString(),
      pageNumber: null,
      pageSize: null,
      totalRecord: null,
    );
  }

  Future<Options> defaultOptions({required String url}) async {
    String? token = //SharedPreferencesStorage().getAccessToken();
        await SecureStorage().readSecureData(AppConstants.accessTokenKey);

    String refreshToken =
        await SecureStorage().readSecureData(AppConstants.refreshTokenKey);
    if (kDebugMode) {
      if (isNotNullOrEmpty(url)) {
        print('URL: $url');
      }
      log('TOKEN: $token');
      log('REF: $refreshToken');
    }
    if (isNullOrEmpty(token)) {
      log('TOKEN NULL');
      return Options();
    } else {
      return Options(
        headers: {
          'Authorization': token!,
        },
      );
    }
  }

  Options optionsToFCMServer() => Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': AppConstants.fcmTokenServerKey,
        },
      );

  //for set options timeOut waiting request dio connect to servers
  Options baseOption() => Options(
        sendTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        receiveDataWhenStatusError: true,
      );

  Future<bool> isExpiredToken() async {
    _authenticationProvider ??= AuthProvider();
    return !(await _authenticationProvider?.checkAuthenticationStatus() ??
        false);
  }
}
