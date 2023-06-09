import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/base_response.dart';
import 'package:chat_app/network/response/student_response.dart';
import 'package:path/path.dart';

import '../api/api_path.dart';
import '../response/base_get_response.dart';
import '../response/list_student_response.dart';

class StudentProvider with ProviderMixin {
  Future<BaseGetResponse> getListStudent({
    required Map<String, dynamic> queryParameters,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.listStudent,
        queryParameters: queryParameters,
        options: await defaultOptions(url: ApiPath.listStudent),
      );

      return ListStudentsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listStudent);
    }
  }

  Future<BaseResponse> getStudentBySSID({required String studentSSID}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.getStudentInfo,
        queryParameters: {'code': studentSSID},
        options: await defaultOptions(url: ApiPath.getStudentInfo),
      );

      return StudentResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, ApiPath.getStudentInfo);
    }
  }

  Future<Object> getStudentByID({required int studentId}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    final apiGetStudentByID =
        join(ApiPath.getStudentInfo, studentId.toString());
    try {
      final response = await dio.get(
        apiGetStudentByID,
        options: await defaultOptions(url: apiGetStudentByID),
      );

      return Student.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiGetStudentByID);
    }
  }

  Future<Object> addStudent({required Map<String, dynamic> data}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.listStudent,
        data: data,
        options: await defaultOptions(url: ApiPath.listStudent),
      );

      return Student.fromJson(response.data);
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
      return ExpiredTokenResponse();
    }
    try {
      final response = await dio.put(
        apiEditStudent,
        data: data,
        options: await defaultOptions(url: apiEditStudent),
      );

      return Student.fromJson(response.data);
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
