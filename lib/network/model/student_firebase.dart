class StudentFirebase {
  final String? studentId;
  final String? studentName;
  final String? dob;
  final String? imageUrl;
  final String? className;

  StudentFirebase({
    this.studentId,
    this.studentName,
    this.dob,
    this.imageUrl,
    this.className,
  });

  factory StudentFirebase.fromJson(Map<String, dynamic> json) =>
      StudentFirebase(
        studentId: json['studentId'],
        studentName: json['studentName'],
        dob: json['dob'],
        imageUrl: json['imageUrl'],
        className: json['className'],
      );

  Map<String, dynamic> toFirestore() => {
        'studentId': studentId,
        'studentName': studentName,
        'dob': dob,
        'imageUrl': imageUrl,
        'className': className
      };
}
