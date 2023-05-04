import 'dart:developer';

import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/class_response.dart';

import '../api/api_path.dart';
import '../response/base_get_response.dart';

class ClassProvider with ProviderMixin {
  Future<BaseGetResponse> getListClass() async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.listClass,
        options: await defaultOptions(url: ApiPath.listClass),
      );
      log(response.toString());

      return ClassResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listClass);
    }
  }
}
