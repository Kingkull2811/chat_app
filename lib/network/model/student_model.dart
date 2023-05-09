import 'package:chat_app/network/model/class_model.dart';

class StudentModel {
  final int? studentId;
  final String? studentName;
  final String? dob;
  final String? imageUrl;
  final ClassModel? classInfo;

  StudentModel({
    this.studentId,
    this.studentName,
    this.dob,
    this.imageUrl,
    this.classInfo,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        studentId: json['id'],
        studentName: json['name'],
        dob: json['dateOfBirth'],
        imageUrl: json['imageUrl'],
        classInfo: ClassModel.fromJson(json['classResponse']),
      );

  @override
  String toString() {
    return 'StudentModel{studentId: $studentId, studentName: $studentName, dob: $dob, imageUrl: $imageUrl, classInfo: $classInfo}';
  }
}
