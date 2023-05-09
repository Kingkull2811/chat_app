import 'package:chat_app/network/provider/class_provider.dart';

import '../response/base_get_response.dart';

class ClassRepository {
  final _classProvider = ClassProvider();

  ///class
  Future<BaseGetResponse> getListClass() async =>
      await _classProvider.getListClass();

  Future<Object> addClass({required Map<String, dynamic> data}) async =>
      await _classProvider.addClass(data: data);

  Future<Object> editClass(
          {required int classId, required Map<String, dynamic> data}) async =>
      await _classProvider.editClass(classId: classId, data: data);

  Future<Object> deleteClass({required int classId}) async =>
      await _classProvider.deleteClass(classId: classId);

  ///subject
  Future<BaseGetResponse> getListSubject() async =>
      await _classProvider.getListSubject();

  Future<Object> addSubject({required Map<String, dynamic> data}) async =>
      await _classProvider.addSubject(data: data);

  Future<Object> editSubject(
          {required int subjectId, required Map<String, dynamic> data}) async =>
      await _classProvider.editSubject(subjectId: subjectId, data: data);

  Future<Object> deleteSubject({required int subjectId}) async =>
      await _classProvider.deleteSubject(subjectId: subjectId);
}
