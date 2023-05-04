import 'package:chat_app/network/model/subject_model.dart';
import 'package:chat_app/utilities/utils.dart';

class ClassModel {
  final int? classId;
  final String? className;
  final String? code;
  final List<SubjectModel>? subjectData;
  final String? schoolYear;

  ClassModel({
    this.classId,
    this.className,
    this.code,
    this.subjectData,
    this.schoolYear,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
        classId: json['id'],
        className: json['name'],
        code: json['code'],
        subjectData: isNullOrEmpty(json['subjectDatas'])
            ? []
            : List<SubjectModel>.generate(
                json['subjectDatas'].length,
                (index) => SubjectModel.fromJson(json['subjectDatas'][index]),
              ),
        schoolYear: json['year'],
      );

  @override
  String toString() {
    return 'ClassModel{classId: $classId, className: $className, code: $code, subjectData: $subjectData, schoolYear: $schoolYear}';
  }
}
