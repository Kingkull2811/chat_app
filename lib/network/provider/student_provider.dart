import 'dart:developer';

import 'package:chat_app/network/provider/provider_mixin.dart';

import '../api/api_path.dart';
import '../response/base_get_response.dart';
import '../response/student_response.dart';

class StudentProvider with ProviderMixin {
  Future<BaseGetResponse> getListStudent() async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.listStudent,
        options: await defaultOptions(url: ApiPath.listStudent),
      );
      log(response.toString());

      return ListStudentResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listStudent);
    }
  }

  Future<Object> addStudent(Object data) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.listStudent,
        options: await defaultOptions(url: ApiPath.listStudent),
      );
      log(response.toString());

      return StudentResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, ApiPath.listStudent);
    }
  }
}
