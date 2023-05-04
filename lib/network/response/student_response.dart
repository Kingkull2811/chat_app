import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/network/response/base_response.dart';

import '../../utilities/utils.dart';
import '../model/error.dart';
import '../model/student_model.dart';

class StudentResponse extends BaseResponse {
  final StudentModel? data;

  StudentResponse({
    int? httpStatus,
    String? message,
    List<Errors>? errors,
    this.data,
  }) : super(
          httpStatus: httpStatus,
          message: message,
          errors: errors,
        );

  factory StudentResponse.fromJson(Map<String, dynamic> json) =>
      StudentResponse(
        httpStatus: json["httpStatus"],
        message: json["message"],
        errors: isNotNullOrEmpty(json["errors"])
            ? List.generate(
                json["errors"].length,
                (index) => Errors.fromJson(json["errors"][index]),
              )
            : [],
        data: json[""] == null ? null : StudentModel.fromJson(json[""]),
      );
}

class ListStudentResponse extends BaseGetResponse {
  final List<StudentModel>? listStudent;

  ListStudentResponse({
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

  factory ListStudentResponse.fromJson(Map<String, dynamic> json) =>
      ListStudentResponse(
        listStudent: isNullOrEmpty(json['content'])
            ? []
            : List.generate(
                json['content'].length,
                (index) => StudentModel.fromJson(json['content'][index]),
              ),
        pageNumber: json['pageNumber'],
        pageSize: json['pageSize'],
        totalRecord: json['totalRecord'],
        status: json['status'],
        error: json['error'],
      );
}
