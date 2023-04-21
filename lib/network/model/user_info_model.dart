import '../../utilities/utils.dart';

class UserInfoModel {
  final int? id;
  final String? username;
  final String? email;
  final List<Role>? roles;
  final String? fullName;
  final String? phone;
  final bool isFillProfileKey;
  final String? fileUrl;

  UserInfoModel({
    this.id,
    this.username,
    this.email,
    this.roles,
    this.fullName,
    this.phone,
    this.isFillProfileKey = false,
    this.fileUrl,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: isNullOrEmpty(json['roles'])
          ? []
          : List<Role>.from(
              json['roles'].map((role) => Role.fromJson(role)),
            ),
      fullName: json['fullName'],
      phone: json['phone'],
      isFillProfileKey: json['isFillProfileKey'] ?? false,
      fileUrl: isNullOrEmpty(json['fileUrl']) ? null : json['fileUrl'],
    );
  }

  @override
  String toString() {
    return 'UserInfoModel{id: $id, username: $username, email: $email, roles: $roles, fullName: $fullName, phone: $phone, isFillProfileKey: $isFillProfileKey, fileUrl: $fileUrl}';
  }
}

class Role {
  final int? id;
  final String? name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'Role{id: $id, name: $name}';
  }
}
