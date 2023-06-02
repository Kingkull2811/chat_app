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
  final double? mediumScore;
  final double? hk1SubjectMediumScore;
  final double? hk2SubjectMediumScore;

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
      id: json['id'],
      name: json['name'],
      code: json['code'],
      dateOfBirth: json['dateOfBirth'],
      imageUrl: json['imageUrl'],
      className: json['className'],
      classResponse: isNotNullOrEmpty(json['classResponse'])
          ? ClassModel.fromJson(json['classResponse'])
          : null,
      mediumScore: (json['mediumScore'] == null)
          ? null
          : double.tryParse(json['mediumScore'].toString()) ?? 0.0,
      hk1SubjectMediumScore: (json['hk1SubjectMediumScore'] == null)
          ? null
          : double.tryParse(json['hk1SubjectMediumScore'].toString()) ?? 0.0,
      hk2SubjectMediumScore: (json['hk2SubjectMediumScore'] == null)
          ? null
          : double.tryParse(json['hk2SubjectMediumScore'].toString()) ?? 0.0,
    );
  }

  @override
  String toString() {
    return '\nStudent{id: $id, name: $name, code: $code, className: $className, classResponse: $classResponse}';
  }
}
