import 'package:chat_app/network/response/base_get_response.dart';

import '../../utilities/utils.dart';
import '../model/subject_model.dart';

class SubjectResponse extends BaseGetResponse {
  final List<SubjectModel>? listSubject;

  SubjectResponse({
    this.listSubject,
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

  factory SubjectResponse.fromJson(Map<String, dynamic> json) =>
      SubjectResponse(
        listSubject: isNullOrEmpty(json['content'])
            ? []
            : List.generate(
                json['content'].length,
                (index) => SubjectModel.fromJson(json['content'][index]),
              ),
        pageNumber: json['pageNumber'],
        pageSize: json['pageSize'],
        totalRecord: json['totalRecord'],
        status: json['status'],
        error: json['error'],
      );

  @override
  String toString() {
    return 'SubjectResponse{listSubject: $listSubject}';
  }
}
