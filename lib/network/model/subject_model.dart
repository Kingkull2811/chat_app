class SubjectModel {
  final int? subjectId;
  final String? subjectName;
  final String? code;

  SubjectModel({
    this.subjectId,
    this.subjectName,
    this.code,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        code: json['code'],
        subjectId: json['id'],
        subjectName: json['name'],
      );

  @override
  String toString() {
    return 'SubjectModel{subjectId: $subjectId, subjectName: $subjectName, code: $code}';
  }
}
