// import 'dart:io';
//
// import 'package:chat_app/utilities/shared_preferences_storage.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationServices {
//   //initialising firebase message plugin
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   //initialising firebase message plugin
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   //function to initialise flutter local notification plugin to show notifications for android when app is active
//   void initLocalNotifications(
//     BuildContext context,
//     RemoteMessage message,
//   ) async {
//     var androidInitializationSettings = const AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     // var iosInitializationSettings = const DarwinInitializationSettings();
//     var iosInitializationSettings = IOSInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: false,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (
//         int id,
//         String? title,
//         String? body,
//         String? payload,
//       ) async {
//         // didReceiveLocalNotificationSubject.add(
//         //   ReceivedNotification(
//         //     id: id,
//         //     title: title,
//         //     body: body,
//         //     payload: payload,
//         //   ),
//         // );
//       },
//     );
//
//     var initializationSetting = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSetting,
//       onSelectNotification: (payload) {
//         // handle interaction when app is active for android
//         handleMessage(context, message);
//       },
//     );
//   }
//
//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;
//
//       if (kDebugMode) {
//         print("notifications title:${notification!.title}");
//         print("notifications body:${notification.body}");
//         print('count:${android!.count}');
//         print('data:${message.data.toString()}');
//       }
//
//       if (Platform.isIOS) {
//         foregroundMessage();
//       }
//
//       if (Platform.isAndroid) {
//         initLocalNotifications(context, message);
//       }
//     });
//   }
//
//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       //appSetting.AppSettings.openNotificationSettings();
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }
//
//   //function to get device token on which we will send the notifications
//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     await SharedPreferencesStorage().setFCMToken(token!);
//     return token;
//   }
//
//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen(
//       (event) async {
//         event.toString();
//         await SharedPreferencesStorage().setFCMToken(event);
//         // log('refresh fcm Token: $event');
//       },
//     );
//   }
//
//   //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(BuildContext context) async {
//     // when app is terminated
//     RemoteMessage? initialMessage = await messaging.getInitialMessage();
//
//     if (initialMessage != null) {
//       handleMessage(context, initialMessage);
//     }
//
//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });
//   }
//
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if (message.data['type'] == 'kull_chat') {
//       if (kDebugMode) {
//         print('message: ${message.data['id']}');
//       }
//     }
//   }
//
//   Future foregroundMessage() async {
//     await messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
// }
