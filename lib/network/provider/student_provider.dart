import 'dart:developer';

import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:path/path.dart';

import '../api/api_path.dart';
import '../response/base_get_response.dart';
import '../response/list_student_response.dart';
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

      return ListStudentsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listStudent);
    }
  }

  Future<Object> getStudentBySSID({required String studentSSID}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.getStudentInfo,
        queryParameters: {'code': studentSSID},
        options: await defaultOptions(url: ApiPath.getStudentInfo),
      );
      log(response.toString());

      return Student.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.getStudentInfo);
    }
  }

  Future<Object> addStudent({required Map<String, dynamic> data}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.listStudent,
        data: data,
        options: await defaultOptions(url: ApiPath.listStudent),
      );
      log(response.toString());

      return StudentResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, ApiPath.listStudent);
    }
  }

  Future<Object> editStudent({
    required int studentId,
    required Map<String, dynamic> data,
  }) async {
    final apiEditStudent = join(ApiPath.listStudent, studentId.toString());

    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.put(
        apiEditStudent,
        data: data,
        options: await defaultOptions(url: apiEditStudent),
      );
      log(response.toString());

      return StudentResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, apiEditStudent);
    }
  }

  Future<Object> deleteStudent({required int studentId}) async {
    final apiDeleteStudent = join(ApiPath.listStudent, studentId.toString());

    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      return await dio.delete(
        apiDeleteStudent,
        options: await defaultOptions(url: apiDeleteStudent),
      );
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, apiDeleteStudent);
    }
  }
}
