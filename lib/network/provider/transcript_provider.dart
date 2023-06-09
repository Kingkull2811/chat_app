import 'dart:developer';

import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/model/learning_result_info.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:path/path.dart';

import '../response/base_response.dart';

class TranscriptProvider with ProviderMixin {
  Future<Object> updatePoint({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    if (await isExpiredToken()) {
      return BaseGetResponse();
    }
    final String apiUpdate = join(ApiPath.learningResult, id.toString());

    try {
      final response = await dio.put(
        apiUpdate,
        data: data,
        options: await defaultOptions(url: apiUpdate),
      );
      log(response.data.toString());

      return LearningResultInfo.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiUpdate);
    }
  }

  Future<BaseResponse> mathGPA({
    required int studentID,
    required String schoolYear,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.learningResult,
        queryParameters: {
          'semesterYear': schoolYear,
          'studentId': studentID,
        },
        options: await defaultOptions(url: ApiPath.learningResult),
      );

      return BaseResponse(
        httpStatus: response.statusCode,
        message: response.data.toString(),
      );
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, ApiPath.learningResult);
    }
  }
}
