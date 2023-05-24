import 'package:chat_app/network/model/student_firebase.dart';
import 'package:chat_app/utilities/utils.dart';

class UserFirebaseData {
  final int? id;
  final String? username;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? fileUrl;
  final List<StudentFirebase>? parentOf;
  String? fcmToken;

  UserFirebaseData({
    this.id,
    this.fullName,
    this.fileUrl,
    this.username,
    this.email,
    this.phone,
    this.parentOf,
    this.fcmToken,
  });

  factory UserFirebaseData.fromFirebase(Map<String, dynamic> json) =>
      UserFirebaseData(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        fullName: json['fullName'],
        phone: json['phone'],
        fileUrl: json['fileUrl'],
        parentOf: isNullOrEmpty(json['parentOf'])
            ? []
            : List.from(
                (json['parentOf']).map((e) => StudentFirebase.fromJson(e)),
              ),
        fcmToken: json['fcm_token'],
      );

  @override
  String toString() {
    return 'UserFirebaseData{id: $id, username: $username, email: $email, fullName: $fullName, phone: $phone, fileUrl: $fileUrl, parentOf: $parentOf, fcmToken: $fcmToken}';
  }
}
