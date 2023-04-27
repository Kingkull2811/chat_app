import 'dart:developer';
import 'dart:io';

import 'package:chat_app/network/model/user_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  late FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  UploadTask uploadTask(String imagePath, String fileName) {
    Reference reference =
        firebaseStorage.ref().child('images').child('/$fileName');
    UploadTask uploadTask = reference.putFile(File(imagePath));
    reference.getDownloadURL();
    return uploadTask;
  }

  Future<void> uploadDataFireStore(
    String collectionPath,
    String path,
    Map<String, String> dataNeedUpdate,
  ) {
    return firebaseFirestore
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
          firebaseStorage.ref().child('images').child('/$fileName');
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

  Future<dynamic> uploadUserData() async {
    // UploadTask uploadTask = ;

    try {
      // TaskSnapshot taskSnapshot  = await uploadTask;
      // String imageUrl = await taskSnapshot.ref.getDownloadURL();

      UserFirebaseData userData = UserFirebaseData(
        userId: '',
        username: '',
        email: '',
        phone: '',
        token: '',
        role: 'UserRole.user',
        parentOf: '',
      );

      uploadDataFireStore('account', 'path', userData.toJson())
          .then((value) async {})
          .catchError((onError) {});
    } on FirebaseException catch (_) {}
  }

// Future<DocumentReference> addMessageToGuestBook(String message) async {
//
//
//   // if (!_loggedIn) {
//   //   throw Exception('Must be logged in');
//   // }
//
//   return firebaseFirestore.collection('chat').add(<String, dynamic>{
//     'message': message,
//     'timestamp': DateTime.now().millisecondsSinceEpoch,
//     // 'name': FirebaseAuth.instance.currentUser!.displayName,
//     // 'userId': FirebaseAuth.instance.currentUser!.uid,
//     'sender': _prefs.getString(AppConstants.usernameKey),
//     'userId': _prefs.getString(AppConstants.userIdKey),
//     'typeMessage': TypeMessage.text,
//     'status': MessageStatus.notView,
//   });
// }
}
