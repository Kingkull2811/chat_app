import '../../utilities/utils.dart';
import '../model/student.dart';
import 'base_get_response.dart';

class ListStudentsResponse extends BaseGetResponse {
  final List<Student>? listStudent;

  ListStudentsResponse({
    this.listStudent,
    int? pageNumber,
    int? pageSize,
    int? totalRecord,
    int? status,
    String? error,
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          totalRecord: totalRecord,
          status: status,
          error: error,
        );

  factory ListStudentsResponse.fromJson(Map<String, dynamic> json) =>
      ListStudentsResponse(
        listStudent: isNullOrEmpty(json['content'])
            ? []
            : List.generate(
                json['content'].length,
                (index) => Student.fromJson(json['content'][index]),
              ),
        pageNumber: json['pageNumber'],
        pageSize: json['pageSize'],
        totalRecord: json['totalRecord'],
        status: json['status'],
        error: json['error'],
      );

  @override
  String toString() {
    return 'ListStudentsResponse{listStudent: $listStudent}';
  }
}
