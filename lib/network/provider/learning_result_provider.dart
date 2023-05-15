import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';

import '../response/base_get_response.dart';
import '../response/learning_result_info_response.dart';

class LearningResultProvider with ProviderMixin {
  Future<Object> getListSubjectPoint({
    required Map<String, dynamic> queryParameters,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.learningResult,
        queryParameters: queryParameters,
        options: await defaultOptions(url: ApiPath.learningResult),
      );
      return LearningResultInfoResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.learningResult);
    }
  }
}
