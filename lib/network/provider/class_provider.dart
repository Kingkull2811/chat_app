import 'package:chat_app/network/model/class_model.dart';
import 'package:chat_app/network/model/subject_model.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/class_response.dart';
import 'package:chat_app/network/response/subject_response.dart';
import 'package:path/path.dart';

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
      return ClassResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listClass);
    }
  }

  Future<Object> addClass({required Map<String, dynamic> data}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.listClass,
        data: data,
        options: await defaultOptions(url: ApiPath.listClass),
      );
      return ClassModel.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listSubject);
    }
  }

  Future<Object> editClass({
    required int classId,
    required Map<String, dynamic> data,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    final apiEditClass = join(ApiPath.listClass, classId.toString());
    try {
      final response = await dio.put(
        apiEditClass,
        data: data,
        options: await defaultOptions(url: apiEditClass),
      );
      return ClassModel.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiEditClass);
    }
  }

  Future<Object> deleteClass({
    required int classId,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    final apiDeleteClass = join(ApiPath.listClass, classId.toString());
    try {
      return await dio.delete(
        apiDeleteClass,
        options: await defaultOptions(url: apiDeleteClass),
      );
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiDeleteClass);
    }
  }

  Future<BaseGetResponse> getListSubject() async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.listSubject,
        options: await defaultOptions(url: ApiPath.listSubject),
      );

      return SubjectResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listSubject);
    }
  }

  Future<Object> addSubject({required Map<String, dynamic> data}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.listSubject,
        data: data,
        options: await defaultOptions(url: ApiPath.listSubject),
      );
      return SubjectModel.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listSubject);
    }
  }

  Future<Object> editSubject({
    required int subjectId,
    required Map<String, dynamic> data,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    final apiEditSubject = join(ApiPath.listSubject, subjectId.toString());
    try {
      final response = await dio.put(
        apiEditSubject,
        data: data,
        options: await defaultOptions(url: apiEditSubject),
      );
      return SubjectModel.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiEditSubject);
    }
  }

  Future<Object> deleteSubject({
    required int subjectId,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    final apiEditSubject = join(ApiPath.listSubject, subjectId.toString());
    try {
      return await dio.delete(
        apiEditSubject,
        options: await defaultOptions(url: apiEditSubject),
      );
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiEditSubject);
    }
  }
}
