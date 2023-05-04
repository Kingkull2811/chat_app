import 'package:chat_app/network/model/class_model.dart';
import 'package:chat_app/network/response/base_get_response.dart';

import '../../utilities/utils.dart';

class ClassResponse extends BaseGetResponse {
  final List<ClassModel>? listClass;

  ClassResponse({
    this.listClass,
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

  factory ClassResponse.fromJson(Map<String, dynamic> json) => ClassResponse(
        listClass: isNullOrEmpty(json['content'])
            ? []
            : List.generate(
                json['content'].length,
                (index) => ClassModel.fromJson(json['content'][index]),
              ),
        pageNumber: json['pageNumber'],
        pageSize: json['pageSize'],
        totalRecord: json['totalRecord'],
        status: json['status'],
        error: json['error'],
      );
}
