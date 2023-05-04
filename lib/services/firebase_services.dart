import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/network/model/user_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../network/model/message_model.dart';
import '../utilities/enum/message_type.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  UploadTask uploadTask(String imagePath, String fileName) {
    Reference reference =
        _firebaseStorage.ref().child('images').child('/$fileName');
    UploadTask uploadTask = reference.putFile(File(imagePath));
    reference.getDownloadURL();
    return uploadTask;
  }

  Future<void> uploadDataFireStore(
    String collectionPath,
    String path,
    Map<String, String> dataNeedUpdate,
  ) {
    return _firestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  uploadImageToStorage({
    required String titleName,
    required File image,
  }) async {
    try {
      String fileName = '${titleName}_${DateTime.now().microsecondsSinceEpoch}';
      Reference reference =
          _firebaseStorage.ref().child('images').child('/$fileName');
      UploadTask uploadTask = reference.putFile(image);

      uploadTask.snapshotEvents.listen((event) {
        if (kDebugMode) {
          print('processing ${event.bytesTransferred}/${event.totalBytes}');
        }
      });
      await uploadTask.whenComplete(() => null);
      String imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> uploadUserData({
    int? userId,
    required Map<String, dynamic> data,
    SetOptions? options,
  }) async {
    if (userId == null) {
      return;
    }
    try {
      await _firestore
          .collection('users')
          .doc('user_id_$userId')
          .set(data, options)
          .whenComplete(
            () => log('upload userInfo done'),
          );
    } on FirebaseException catch (_) {}
  }

  Future<UserInfoModel?> getUserInfoFirebase({required int userId}) async {
    final snapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: userId.toString())
        .get();

    final userInfo =
        snapshot.docs.map((e) => UserInfoModel.fromSnapshot(e)).first;
    log('data: $userInfo');

    return userInfo;
  }

  Future<List<UserInfoModel>> getAllUser() async {
    List<UserInfoModel> listUser = [];
    try {
      // final snapshot = await firebaseFirestore.collection('users').get();
      // listUser =
      //     snapshot.docs.map((e) => UserInfoModel.fromSnapshot(e)).toList();

      final data = await _firestore.collection('users').get();
      log("data: ${data.docs.toString()}");

      data.docs.forEach((element) {
        return listUser.add(UserInfoModel.fromFirebase(element.data()));
      });
      return listUser;
    } on FirebaseException catch (e) {
      log(e.toString());
      return listUser;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<UserInfoModel>> getAllProfile() async {
    Completer<List<UserInfoModel>> completer = Completer<List<UserInfoModel>>();
    final List<UserInfoModel> profiles = [];
    await _firestore
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docChanges) {
        final doc = element.doc;
        if (doc.exists) {
          if (doc.data() is Map<String, dynamic>) {
            log('data: ${doc.data() as Map<String, dynamic>}');
            final profile =
                UserInfoModel.fromFire(doc.data() as Map<String, dynamic>);
            profiles.add(profile);
          }
        }
      }
      log('list user: $profiles');
      completer.complete(profiles);
    });
    return completer.future;
    // return profiles;
  }

  Future<DocumentReference> sendMessageToFirebase(
    String receiverId,
    MessageModel message,
  ) async {
    return await _firestore
        .collection('message')
        .doc('receiver_id_$receiverId')
        .collection('listMessage')
        .add(<String, dynamic>{
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      // 'name': FirebaseAuth.instance.currentUser!.displayName,
      // 'userId': FirebaseAuth.instance.currentUser!.uid,
      'sender': '',
      'userId': '',
      'typeMessage': MessageType.text,
    });
  }
}
