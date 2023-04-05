
class UserFirebaseData {
  final String? userId;
  final String? username;
  final String? email;
  final String? phone;
  final String? avartarUrl;
  final String? token;
  final String? role;
  final String? parentOf;

  UserFirebaseData({
    this.userId,
    this.username,
    this.email,
    this.phone,
    this.avartarUrl,
    this.token,
    this.role,
    this.parentOf,
  });

  factory UserFirebaseData.fromJson(Map<String, dynamic> json) =>
      UserFirebaseData(
        userId: json['userId'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
        avartarUrl: json['avartarUrl'],
        token: json['json'],
        role: json['role'],
        parentOf: json['parentOf'],
      );

  Map<String, String> toJson() {
    return {
      "userId": userId.toString(),
      "username": username.toString(),
      "email": email.toString(),
      "phone": phone.toString(),
      "avartarUrl": avartarUrl.toString(),
      "json": token.toString(),
      "role": role.toString(),
      "parentOf": parentOf.toString(),
    };
  }

  // factory UserFirebaseData.fromDocument(DocumentSnapshot doc){
  //
  //   String userId = '';
  //   String username = '';
  //   String email = '';
  //   String phone = '';
  //   String avartarUrl = '';
  //   String token = '';
  //   UserRole role = UserRole.user;
  //   String parentOf = '';
  //
  //   try{
  //     userId = doc.get("userId");
  //   }
  //   catch (e){}
  //
  //   return UserFirebaseData();
  // }
}
