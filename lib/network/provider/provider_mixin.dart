import 'package:chat_app/network/response/base_get_response.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../utilities/secure_storage.dart';
import '../../utilities/utils.dart';
import '../model/error.dart';
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
      print("\nEXCEPTION WITH: $error\nSTACKTRACE: $stacktrace");
    } else {
      //record log to firebase crashlytics here
      FirebaseCrashlytics.instance.setCustomKey("$error", "ERROR in $apiPath");

      FirebaseCrashlytics.instance.recordError("$error", stacktrace, reason: 'fatal');

      FirebaseCrashlytics.instance.log(
        "EXCEPTION OCCURRED: $apiPath\nEXCEPTION WITH: $error\nSTACKTRACE: $stacktrace",
      );
    }
  }

  BaseResponse errorResponse(error, stacktrace, apiPath) {
    showErrorLog(error, stacktrace, apiPath);

    List<dynamic> errors = error.response?.data;

    return BaseResponse.withHttpError(
      errors: errors.map((e) => Errors.fromJson(e)).toList(),
      httpStatus: error.response?.statusCode,
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
    String token = await SecureStorage().getAccessToken();

    if (kDebugMode) {
      if (isNotNullOrEmpty(url)) {
        print('URL: $url');
      }
      // log('TOKEN: $token');
    }

    return Options(
      headers: {
        'Authorization': token,
      },
    );
  }

  //for set options timeOut waiting request dio connect to servers
  Options baseOption() => Options(
        sendTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        receiveDataWhenStatusError: true,
      );

  Future<bool> isExpiredToken() async {
    _authenticationProvider ??= AuthProvider();
    return !(await _authenticationProvider?.checkAuthenticationStatus() ?? false);
  }
}
