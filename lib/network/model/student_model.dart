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

class StudentTranscriptModel {
  final int? studentId;
  final String? studentName;
  final String? dob;
  final String? imageUrl;
  final String? className;
  final double? hk1SubjectMediumScore;
  final double? hk2SubjectMediumScore;
  final double? mediumScore;

  StudentTranscriptModel({
    this.studentId,
    this.studentName,
    this.dob,
    this.imageUrl,
    this.className,
    this.hk1SubjectMediumScore,
    this.hk2SubjectMediumScore,
    this.mediumScore,
  });

  factory StudentTranscriptModel.fromJson(Map<String, dynamic> json) =>
      StudentTranscriptModel(
        studentId: json['id'],
        studentName: json['name'],
        dob: json['dateOfBirth'],
        imageUrl: json['imageUrl'],
        className: json['className'],
        hk1SubjectMediumScore: json['hk1SubjectMediumScore'],
        hk2SubjectMediumScore: json['hk2SubjectMediumScore'],
        mediumScore: json['mediumScore'],
      );

  @override
  String toString() {
    return 'StudentTranscriptModel{studentId: $studentId, studentName: $studentName, dob: $dob, imageUrl: $imageUrl, className: $className, hk1SubjectMediumScore: $hk1SubjectMediumScore, hk2SubjectMediumScore: $hk2SubjectMediumScore, mediumScore: $mediumScore}';
  }
}
