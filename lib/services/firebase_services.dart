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

  Future uploadImageToStorage({
    required String titleName,
    required String childFolder,
    required File image,
  }) async {
    try {
      String fileName = '${titleName}_${DateTime.now().millisecondsSinceEpoch}';
      Reference reference = _firebaseStorage
          .ref()
          .child(AppConstants.imageChild)
          .child(childFolder)
          .child('/$fileName');
      UploadTask uploadTask = reference.putFile(image);

      uploadTask.snapshotEvents.listen((event) async {
        if (kDebugMode) {
          print('processing ${event.bytesTransferred}/${event.totalBytes}');
        }
        switch (event.state) {
          case TaskState.paused:
          case TaskState.running:
          case TaskState.canceled:
          case TaskState.error:
            break;

          case TaskState.success:
            //get imageUrl and send message
            break;
        }
      });
      await uploadTask.whenComplete(() => null);
      String imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      log(e.toString());
    }
  }

  Future uploadUserData({
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

  Future<List<MessageModel>> getListMessage(String docId) async {
    List<MessageModel> listMessage = [];
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
            final message =
                MessageModel.fromJson(doc.data() as Map<String, dynamic>);
            listMessage.add(message);
          }
        }
      }
    });
    return listMessage;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getListChat(int currentUserId) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .where('members.$currentUserId', isNull: true)
        .snapshots();
  }

  Future<String> checkMessageExists({
    required int currentUserId,
    required String receiverId,
    required String receiverAvt,
    required String receiverName,
  }) async {
    var docID;
    await _firestore
        .collection(AppConstants.chatsCollection)
        .where('members',
            isEqualTo: {currentUserId.toString(): null, receiverId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              docID = querySnapshot.docs.single.id;
            } else {
              await _firestore.collection(AppConstants.chatsCollection).add({
                "members": {currentUserId.toString(): null, receiverId: null},
                'names': {
                  currentUserId.toString():
                      SharedPreferencesStorage().getFullName(),
                  receiverId: receiverName
                },
                'imageUrls': {
                  currentUserId.toString():
                      SharedPreferencesStorage().getImageAvartarUrl(),
                  receiverId: receiverAvt
                },
              }).then((value) {
                docID = value.id;
              });
            }
          },
        )
        .catchError((error) {});
    return docID;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessage(var docID) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .doc(docID)
        .collection(AppConstants.messageListCollection)
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> sendTextMessage(
    var docID,
    String messageText,
    int currentUserId,
  ) async {
    final MessageModel message = MessageModel(
      fromId: currentUserId,
      message: messageText,
      messageType: MessageType.text,
      time: Timestamp.now(),
    );

    await _firestore
        .collection(AppConstants.chatsCollection)
        .doc(docID)
        .collection(AppConstants.messageListCollection)
        .withConverter(
            fromFirestore: MessageModel.fromFirestore,
            toFirestore: (MessageModel messageFireStore, options) =>
                messageFireStore.toJson())
        .add(message)
        .then((value) {
      if (kDebugMode) {
        print('docText ${value.id}');
      }
    });
    await _firestore.collection(AppConstants.chatsCollection).doc(docID).update(
      {
        'last_message': message.message,
        'time': message.time,
        'message_type': setMessageType(message.messageType)
      },
    );
  }

  Future<void> sendImageMessage(var docID, String imagePath) async {
    MessageModel message = MessageModel(
      fromId: SharedPreferencesStorage().getUserId(),
      message: await FirebaseService().uploadImageToStorage(
        titleName: 'image_message',
        childFolder: AppConstants.imageMessageChild,
        image: File(imagePath),
      ),
      messageType: MessageType.image,
      time: Timestamp.now(),
    );

    await _firestore
        .collection(AppConstants.chatsCollection)
        .doc(docID)
        .collection(AppConstants.messageListCollection)
        .withConverter(
            fromFirestore: MessageModel.fromFirestore,
            toFirestore: (MessageModel messageFireStore, options) =>
                messageFireStore.toJson())
        .add(message)
        .then((value) {
      if (kDebugMode) {
        print('docImage ${value.id}');
      }
    });
    await _firestore.collection(AppConstants.chatsCollection).doc(docID).update(
      {
        'last_message': '📷 photo',
        'time': message.time,
        'message_type': setMessageType(message.messageType)
      },
    );
  }
}
