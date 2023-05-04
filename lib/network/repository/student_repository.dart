import 'package:chat_app/network/provider/student_provider.dart';
import 'package:chat_app/network/response/base_get_response.dart';

class StudentRepository {
  final _studentProvider = StudentProvider();

  Future<BaseGetResponse> getListStudent() async =>
      await _studentProvider.getListStudent();

  Future<Object> addStudent({
    required String studentName,
    required int classId,
    required String dob,
    required String semesterYear,
    required String imageUrl,
  }) async {
    final data = {
      "classId": 0,
      "dateOfBirth": "2023-04-29",
      "imageUrl": "string",
      "name": "string",
      "semesterYear": "string"
    };
    return _studentProvider.addStudent(data);
  }
}
