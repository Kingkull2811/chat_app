import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/network/model/user_from_firebase.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../network/model/call_model.dart';
import '../network/model/message_model.dart';
import '../network/repository/push_notification_repository.dart';
import '../utilities/enum/message_type.dart';
import 'notification_controller.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final _prefs = SharedPreferencesStorage();

  /// /// *****************Firebase Service*************

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

  ///user

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

  Future updateOnlineStatus(bool isOnline) async {
    await _firestore
        .collection(AppConstants.userCollection)
        .doc('user_id_${_prefs.getUserId()}')
        .update({'isOnline': isOnline});
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

  ///message - chat

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
          // log('data: ${doc.data().toString()}');
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
        // .orderBy('time', descending: true)
        .where('members.$currentUserId', isNull: true)
        .snapshots();
  }

  Future<String> checkMessageExists({
    required int currentUserId,
    required String receiverId,
    required String receiverAvt,
    required String receiverName,
    required String receiverFCMToken,
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
              await _firestore
                  .collection(AppConstants.userCollection)
                  .doc(docID)
                  .update(
                {
                  'fcm_token_$currentUserId':
                      await NotificationController.requestFirebaseToken(),
                  'fcm_token_$receiverId': receiverFCMToken,
                },
              );
            } else {
              await _firestore.collection(AppConstants.chatsCollection).add(
                {
                  "members": {
                    currentUserId.toString(): null,
                    receiverId: null,
                  },
                  'names': {
                    currentUserId.toString(): _prefs.getFullName(),
                    receiverId: receiverName,
                  },
                  'imageUrls': {
                    currentUserId.toString(): _prefs.getImageAvartarUrl(),
                    receiverId: receiverAvt,
                  },
                  'fcm_token_$currentUserId':
                      await NotificationController.requestFirebaseToken(),
                  'fcm_token_$receiverId': receiverFCMToken,
                  'time': Timestamp.now(),
                },
              ).then((value) => docID = value.id);
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

  Future<void> deleteChat(String docID) async {
    await _firestore
        .collection(AppConstants.chatsCollection)
        .doc(docID)
        .delete();
  }

  Future<void> sendTextMessage({
    required var docID,
    required String messageText,
    required int currentUserId,
    required String receiverFCMToken,
  }) async {
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

    await sendPushNotification(
      receiverFCMToken: receiverFCMToken,
      senderName: _prefs.getFullName(),
      message: message.message,
    );
  }

  Future<void> sendImageMessage(
    var docID,
    String imagePath,
    receiverFCMToken,
  ) async {
    final imageUrl = await FirebaseService().uploadImageToStorage(
      titleName: 'image_message',
      childFolder: AppConstants.imageMessageChild,
      image: File(imagePath),
    );

    MessageModel message = MessageModel(
      fromId: _prefs.getUserId(),
      message: imageUrl,
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

    await sendPushNotification(
      receiverFCMToken: receiverFCMToken,
      senderName: _prefs.getFullName(),
      imageUrl: imageUrl,
    );
  }

  Future<void> sendPushNotification({
    required String receiverFCMToken,
    required String senderName,
    String? message,
    String? imageUrl,
  }) async {
    Map<String, dynamic> data = {
      "to": receiverFCMToken,
      "notification": {
        if (message != null) "body": message,
        "title": senderName,
        "sound": true,
        if (imageUrl != null) 'image': imageUrl,
      },
      "data": {"content_type": "notification", "value": 1},
      "content_available": true,
      "priority": "high"
    };

    await PushNotificationRepository().messagePN(data: data);

    ///send to api fcmGoogle
    // final data2 = {
    //   'to': '/topics/topic', //fcmToken
    //   "notification": {
    //     "title": senderName, //our name should be send
    //     "body": message,
    //     // "android_channel_id": "chats"
    //   },
    //   'data': {
    //     'type': 'dataType',
    //     'id': 'id',
    //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    //   }
    // };
  }

  ///call - video - audio

  Future<void> sendCallNotification({
    required String channel,
    required String receiverFCMToken,
    required String senderName,
    String? message,
    String? imageUrl,
  }) async {
    final data = {
      "to": receiverFCMToken,
      "notification": {
        "body": "$senderName is calling you",
        "title": "Incoming Call",
        "sound": true
      },
      "data": {"content_type": channel, "value": -1},
      "content_available": true,
      "priority": "high"
    };

    await PushNotificationRepository().messagePN(data: data);
  }

  Stream<DocumentSnapshot> callStream() => _firestore
      .collection(AppConstants.callCollection)
      .doc('call_id_${SharedPreferencesStorage().getUserId()}')
      .snapshots();

  Stream<DocumentSnapshot> readStateCall({required String receiverDoc}) =>
      _firestore
          .collection(AppConstants.callCollection)
          .doc(receiverDoc)
          .snapshots();

  Future<bool> updateCallStatus({
    required String receiverDoc,
    required bool isAcceptCall,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.callCollection)
          .doc(receiverDoc)
          .update({'is_accept_call': isAcceptCall});
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> makeVideoCall({
    required CallModel call,
    required String receiverToken,
  }) async {
    try {
      call.hasDialled = true;
      call.isCall = "video";
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isCall = "video";
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await sendCallNotification(
        channel: 'call_video',
        receiverFCMToken: receiverToken,
        senderName: call.receiverName ?? '',
      );

      await _firestore
          .collection(AppConstants.callCollection)
          .doc('call_id_${call.callerId}')
          .set(hasDialledMap);

      await _firestore
          .collection(AppConstants.callCollection)
          .doc('call_id_${call.receiverId}')
          .set(hasNotDialledMap);

      return true;
    } catch (e) {
      log(e.toString());

      return false;
    }
  }

  Future<bool> makeVoiceCall({
    required CallModel call,
    required String receiverToken,
  }) async {
    try {
      call.hasDialled = true;
      call.isCall = "audio";
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isCall = "audio";
      call.isAcceptCall = null;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await sendCallNotification(
        channel: 'call_audio',
        receiverFCMToken: receiverToken,
        senderName: call.receiverName ?? '',
      );

      await _firestore
          .collection(AppConstants.callCollection)
          .doc('call_id_${call.callerId}')
          .set(hasDialledMap);

      await _firestore
          .collection(AppConstants.callCollection)
          .doc('call_id_${call.receiverId}')
          .set(hasNotDialledMap);

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> endCall({required CallModel call}) async {
    try {
      await _firestore
          .collection(AppConstants.callCollection)
          .doc('call_id_${call.callerId}')
          .delete();

      await _firestore
          .collection(AppConstants.callCollection)
          .doc('call_id_${call.receiverId}')
          .delete();

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  ///************** FCM Notification*******

  Future<void> sendCurrentDeviceFCMToken({int? userId, String? docID}) async {
    if (userId != null) {
      await _firestore
          .collection(AppConstants.userCollection)
          .doc('user_id_$userId')
          .update({
        'fcm_token': await NotificationController.requestFirebaseToken()
      });
    }

    if (isNotNullOrEmpty(docID)) {
      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(docID)
          .update(
        {
          'fcm_token_${_prefs.getUserId()}':
              await NotificationController.requestFirebaseToken(),
        },
      );
    }
  }

  String constructFCMPayload(String? token) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': '10',
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#10) was created via FCM!',
      },
    });
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          if (kDebugMode) {
            print(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
            );
          }
          // await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          if (kDebugMode) {
            print(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
            );
          }
        }
        break;
      case 'unsubscribe':
        {
          if (kDebugMode) {
            print(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
            );
          }
          // await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          if (kDebugMode) {
            print(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
            );
          }
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            if (kDebugMode) {
              print('FlutterFire Messaging Example: Getting APNs token...');
            }
            // String? token = await FirebaseMessaging.instance.getAPNSToken();
            if (kDebugMode) {
              print('FlutterFire Messaging Example: Got APNs token: ');
            }
          } else {
            if (kDebugMode) {
              print(
                'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
              );
            }
          }
        }
        break;
      default:
        break;
    }
  }
}
