import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/secure_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../response/base_response.dart';
import 'authentication_provider.dart';

mixin ProviderMixin {
  late Dio _dio;
  AuthenticationProvider? _authenticationProvider;

  Dio get dio {
    _dio = Dio()..httpClientAdapter = HttpClientAdapter();
    return _dio;
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
      errors: error,
      httpStatus: (error is DioError) ? error.response?.statusCode : null,
    );
  }

  Future<Options> defaultOptions({
    required String url,
  }) async {
    String token =
    await SecureStorage().readSecureData(AppConstants.accessTokenKey);
    if (kDebugMode) {
      if (isNotNullOrEmpty(url)) {
        print('URL: $url');
      }
      // log('TOKEN - ${AppConstants.buildRegion.toUpperCase()}: $token');
    }
    return Options(
      headers: {
        // 'Authorization': ApiInfo.getAuthorizationString(token),
        // if (AppConstants.buildRegion == AppConstants.regionUS)
        //   'pta_code': SharedPreferencesStorage().getPTAToken(),
        // if (AppConstants.buildRegion == AppConstants.regionUS)
        //   'oscDomain': SharedPreferencesStorage().getOscDomain(),
      },
    );
  }

  Future<bool> isExpiredToken() async {
    _authenticationProvider ??= AuthenticationProvider();
    return !(await _authenticationProvider?.checkAuthenticationStatus() ??
        false);
  }
}
