import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../response/base_response.dart';
import 'api_authentication_provider.dart';

mixin ProviderMixin {
  late Dio _dio;
  ApiAuthenticationProvider? _apiAuthenticationProvider;

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

  Future<bool> isExpiredToken() async {
    _apiAuthenticationProvider ??= ApiAuthenticationProvider();
    return !(await _apiAuthenticationProvider?.checkAuthenticationStatus() ??
        false);
  }
}
