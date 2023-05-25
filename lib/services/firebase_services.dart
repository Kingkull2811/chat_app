import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/network/model/user_from_firebase.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/model/call_model.dart';
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
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final _prefs = SharedPreferencesStorage();

  ///*************initial fcm******************
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  Future<void> initialState(context) async {
    _messaging.getInitialMessage().then(
      (value) {
        // bool resolved = true;
        // String? initialMessage = value?.data.toString();
      },
    );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
    });
  }

  /// /// *****************Firebase Service*************

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
            } else {
              await _firestore.collection(AppConstants.chatsCollection).add({
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
                'fcm_token': {
                  currentUserId.toString(): _prefs.getFCMToken(),
                  receiverId: receiverFCMToken,
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
  }

  Future<void> sendImageMessage(
      var docID, String imagePath, String fcmToken) async {
    MessageModel message = MessageModel(
      fromId: _prefs.getUserId(),
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

  Future<void> sendPushNotification({
    required String receiverFCMToken,
    required String senderName,
    required String message,
  }) async {
    final data = {
      'to': receiverFCMToken,
      "notification": {
        "title": senderName, //our name should be send
        "body": message,
        "android_channel_id": "chats"
      },
    };
    //onTap:
    _messaging.subscribeToTopic('topic');

    final data2 = {
      'to': '/topics/topic', //fcmToken
      "notification": {
        "title": senderName, //our name should be send
        "body": message,
        // "android_channel_id": "chats"
      },
      'data': {
        'type': 'dataType',
        'id': 'id',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      }
    };
  }

  Future<String> getFCMToken() async {
    String fcmToken = '';
    await _messaging.requestPermission();

    await _messaging.getToken().then((token) {
      if (token != null) {
        fcmToken = token;
        if (kDebugMode) {
          print('fcmToken: $token');
        }
      }
    });
    return fcmToken;
  }

  ///call - video - audio

  Stream<DocumentSnapshot> callStream({required String uid}) =>
      _firestore.collection(AppConstants.callCollection).doc(uid).snapshots();

  Future<bool> makeVideoCall({required CallModel call}) async {
    try {
      call.hasDialled = true;
      call.isCall = "video";
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isCall = "video";
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await _firestore
          .collection(AppConstants.callCollection)
          .doc(call.callerId)
          .set(hasDialledMap);

      await _firestore
          .collection(AppConstants.callCollection)
          .doc(call.receiverId)
          .set(hasNotDialledMap);

      return true;
    } catch (e) {
      log(e.toString());

      return false;
    }
  }

  Future<bool> makeVoiceCall({required CallModel call}) async {
    try {
      call.hasDialled = true;
      call.isCall = "audio";
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isCall = "audio";
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await _firestore
          .collection(AppConstants.callCollection)
          .doc(call.callerId)
          .set(hasDialledMap);

      await _firestore
          .collection(AppConstants.callCollection)
          .doc(call.receiverId)
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
          .doc(call.callerId)
          .delete();

      await _firestore
          .collection(AppConstants.callCollection)
          .doc(call.receiverId)
          .delete();

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  ///************** FCM Notification*******

  Future<void> sendFCMTokenToDB(String token, int userId) async {
    await _firestore
        .collection(AppConstants.userCollection)
        .doc('user_id_$userId')
        .update({'fcm_token': token});
  }

  Future<void> sendNotification({
    required String title,
    required String body,
    required String fcmToken,
  }) async {
    FirebaseMessaging.instance.sendMessage(
      to: fcmToken,
      data: {},
      collapseKey: '',
      messageId: '',
      messageType: '',
      ttl: 0,
    );
  }

  String? _token;

  Future<void> sendPushMessage() async {
    if (_token == null) {
      if (kDebugMode) {
        print('Unable to send FCM message, no token exists.');
      }
      return;
    }

    try {
      await Dio().post(
        'https://api.rnfirebase.io/messaging/send',
        data: constructFCMPayload(_token),
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );
      if (kDebugMode) {
        print('FCM request for device sent!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
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
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
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
            String? token = await FirebaseMessaging.instance.getAPNSToken();
            if (kDebugMode) {
              print('FlutterFire Messaging Example: Got APNs token: $token');
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
