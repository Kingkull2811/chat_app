import 'dart:io';

import 'package:chat_app/screens/chats/on_chatting/on_chatting.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  late FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late SharedPreferences _prefs;

  UploadTask uploadTask(File imagePath, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imagePath);
    return uploadTask;
  }

  Future<void> uploadDataFireStore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Future<DocumentReference> addMessageToGuestBook(
      String message, String receiver) async {
    _prefs = await SharedPreferences.getInstance();

    // if (!_loggedIn) {
    //   throw Exception('Must be logged in');
    // }

    return firebaseFirestore.collection('chat').add(<String, dynamic>{
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      // 'name': FirebaseAuth.instance.currentUser!.displayName,
      // 'userId': FirebaseAuth.instance.currentUser!.uid,
      'sender': _prefs.getString(AppConstants.usernameKey),
      'userId': _prefs.getString(AppConstants.userIdKey),
      'receiver': receiver,
      'typeMessage': TypeMessage.text,
      'status': MessageStatus.notView,
    });
  }
}
