import 'package:chat_app/utilities/utils.dart';

import 'class_model.dart';

class Student {
  final int? id;
  final String? name;
  final String? code;
  final String? dateOfBirth;
  final String? imageUrl;
  final String? className;
  final ClassModel? classResponse;
  final dynamic mediumScore;
  final dynamic hk1SubjectMediumScore;
  final dynamic hk2SubjectMediumScore;

  Student({
    this.id,
    this.name,
    this.code,
    this.dateOfBirth,
    this.imageUrl,
    this.className,
    this.classResponse,
    this.mediumScore,
    this.hk1SubjectMediumScore,
    this.hk2SubjectMediumScore,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      imageUrl: json['imageUrl'] as String,
      className: json['className'],
      classResponse: isNotNullOrEmpty(json['classResponse'])
          ? ClassModel.fromJson(json['classResponse'])
          : null,
      mediumScore: json['mediumScore'],
      hk1SubjectMediumScore: json['hk1SubjectMediumScore'],
      hk2SubjectMediumScore: json['hk2SubjectMediumScore'],
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, code: $code, dateOfBirth: $dateOfBirth, imageUrl: $imageUrl}';
  }
}