import 'dart:convert';

import 'package:chat_app/network/model/role_model.dart';
import 'package:chat_app/network/model/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final List<Student>? parentOf;

  UserInfoModel({
    this.id,
    this.username,
    this.email,
    this.roles,
    this.fullName,
    this.phone,
    this.isFillProfileKey = false,
    this.fileUrl,
    this.parentOf,
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
      parentOf: isNullOrEmpty(json['students'])
          ? []
          : List.generate(
              json['students'].length,
              (index) => Student.fromJson(json['students'][index]),
            ),
    );
  }

  factory UserInfoModel.fromFirebase(Map<String, dynamic> data) {
    return UserInfoModel(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      fullName: data['fullName'],
      phone: data['phone'],
      isFillProfileKey: data['isFillProfileKey'] ?? false,
      fileUrl: data['fileUrl'],
      parentOf: data['parentOf'],
    );
  }

  factory UserInfoModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (isNullOrEmpty(snapshot)) {
      return UserInfoModel();
    }
    final data = snapshot.data()!;
    return UserInfoModel(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      roles: List<Role>.from(
        json.decode(data['roles']).map((e) => Role.fromFirebase(e)),
      ),
      fullName: data['fullName'],
      phone: data['phone'],
      isFillProfileKey: data['isFillProfileKey'] ?? false,
      fileUrl: data['fileUrl'],
      parentOf: data['parentOf'],
    );
  }

  factory UserInfoModel.fromFire(Map<String, dynamic> json) {
    return UserInfoModel(
      phone: json['phone'],
      roles: [],
      fullName: json['fullName'],
      fileUrl: json['fileUrl'],
      parentOf: json['parentOf'],
      id: json['id'],
      isFillProfileKey: true,
      email: json['email'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'username': username,
        'email': email,
        'fullName': fullName,
        'phone': phone,
        'fileUrl': fileUrl,
        'parentOf': parentOf,
      };

  @override
  String toString() {
    return 'UserInfoModel{id: $id, username: $username, email: $email, roles: $roles, fullName: $fullName, phone: $phone, isFillProfileKey: $isFillProfileKey, fileUrl: $fileUrl, parentOf: $parentOf}';
  }
}
