import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/network/model/user_from_firebase.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../network/model/message_content_model.dart';

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
      String fileName = '${titleName}_${DateTime.now().toIso8601String()}';
      Reference reference = _firebaseStorage
          .ref()
          .child(AppConstants.imageChild)
          .child('/$fileName');
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
          .collection(AppConstants.userCollection)
          .doc('user_id_$userId')
          .set(data, options)
          .whenComplete(
            () => log('upload userInfo done'),
          );
    } on FirebaseException catch (_) {}
  }

  Future<UserFirebaseData?> getUserDetails({required int userId}) async {
    final snapshot = await _firestore
        .collection(AppConstants.userCollection)
        .doc('user_id_$userId')
        .get();
    if (snapshot.data() == null) {
      return null;
    }
    return UserFirebaseData.fromFirebase(snapshot.data()!);
  }

  Future<List<UserFirebaseData>> getAllProfile() async {
    final List<UserFirebaseData> profiles = [];
    await _firestore
        .collection(AppConstants.userCollection)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docChanges) {
        final doc = element.doc;
        if (doc.exists) {
          if (doc.data() is Map<String, dynamic>) {
            final profile = UserFirebaseData.fromFirebase(
              doc.data() as Map<String, dynamic>,
            );
            profiles.add(profile);
          }
        }
      }
    });
    return profiles;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getListChatByUserID() {
    final int userId = SharedPreferencesStorage().getUserId();
    final snapshot = _firestore
        .collection(AppConstants.messageCollection)
        .where('from_id', isEqualTo: userId)
        // .orderBy('last_time', descending: true)
        .snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot> getListMessageInChatRoom(String docId) {
    final snapshot = _firestore
        .collection(AppConstants.messageCollection)
        .doc(docId)
        .collection(AppConstants.messageListCollection)
        .orderBy('time', descending: false)
        .snapshots();
    return snapshot;
  }

  Future<List<MessageContentModel>> getListMessage(String docId) async {
    List<MessageContentModel> listMessage = [];
    await _firestore
        .collection(AppConstants.messageCollection)
        .doc(docId)
        .collection(AppConstants.messageListCollection)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var element in snapshot.docChanges) {
        final doc = element.doc;
        if (doc.exists) {
          log('data: ${doc.data().toString()}');
          if (doc.data() is Map<String, dynamic>) {
            final message = MessageContentModel.fromJson(
                doc.data() as Map<String, dynamic>);
            listMessage.add(message);
          }
        }
      }
    });
    return listMessage;
  }

  Future<void> sendMessageToFirebase(
    String docId,
    MessageContentModel message,
  ) async {
    await _firestore
        .collection(AppConstants.messageCollection)
        .doc(docId)
        .collection(AppConstants.messageListCollection)
        .withConverter(
            fromFirestore: MessageContentModel.fromFirestore,
            toFirestore: (MessageContentModel messageContent, options) =>
                messageContent.toJson())
        .add(message)
        .then((DocumentReference doc) {
      print('doc ${doc.id}');
    });

    await _firestore
        .collection(AppConstants.messageCollection)
        .doc(docId)
        .update(
      {
        'last_message': message.message,
        'last_time': message.time,
        'message_type': setMessageType(message.messageType)
      },
    );
  }
}
