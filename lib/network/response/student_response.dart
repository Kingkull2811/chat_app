import '../../utilities/utils.dart';
import '../model/error.dart';
import '../model/student_model.dart';
import 'base_response.dart';

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
