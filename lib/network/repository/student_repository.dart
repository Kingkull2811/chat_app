import 'package:chat_app/network/provider/student_provider.dart';
import 'package:chat_app/network/response/base_get_response.dart';

class StudentRepository {
  final _studentProvider = StudentProvider();

  Future<BaseGetResponse> getListStudent({
    required Map<String, dynamic> queryParameters,
  }) async =>
      await _studentProvider.getListStudent(queryParameters: queryParameters);

  Future<Object> getStudentBySSID({required String studentSSID}) async =>
      await _studentProvider.getStudentBySSID(studentSSID: studentSSID);

  Future<Object> getStudentByID({required int studentID}) async =>
      await _studentProvider.getStudentByID(studentId: studentID);

  Future<Object> addStudent({required Map<String, dynamic> data}) async =>
      _studentProvider.addStudent(data: data);

  Future<Object> editStudent({
    required int studentId,
    required Map<String, dynamic> data,
  }) async =>
      _studentProvider.editStudent(studentId: studentId, data: data);

  Future<Object> deleteStudent({required int studentId}) async =>
      _studentProvider.deleteStudent(studentId: studentId);
}
