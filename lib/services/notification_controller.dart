// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
// import 'package:chat_app/theme.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
//
// import '../main.dart';
// import '../utilities/notifications_util.dart';
//
// ///  *********************************************
// ///     NOTIFICATION CONTROLLER
// ///  *********************************************
//
// class NotificationController {
//   static ReceivedAction? initialAction;
//
//   ///  *********************************************
//   ///     INITIALIZATIONS
//   ///  *********************************************
//   static Future<void> initializeLocalNotifications() async {
//     await AwesomeNotifications().initialize(
//       null, // 'resource://drawable/app_icon.png',
//       [
//         NotificationChannel(
//           channelKey: 'kull_chat_app',
//           channelName: 'kull_chat_app',
//           channelDescription: 'Notification kull_chat_app',
//           playSound: true,
//           onlyAlertOnce: true,
//           enableVibration: true,
//           enableLights: true,
//           channelShowBadge: true,
//           groupAlertBehavior: GroupAlertBehavior.Children,
//           importance: NotificationImportance.High,
//           defaultPrivacy: NotificationPrivacy.Private,
//           defaultColor: AppColors.primaryColor,
//           ledColor: AppColors.greyLight,
//         ),
//         NotificationChannel(
//           channelKey: 'call_video',
//           channelName: 'call_video',
//           channelDescription: 'Incoming Video Call',
//           playSound: true,
//           onlyAlertOnce: false,
//           channelShowBadge: true,
//           groupAlertBehavior: GroupAlertBehavior.Children,
//           importance: NotificationImportance.High,
//           defaultPrivacy: NotificationPrivacy.Private,
//           defaultColor: AppColors.primaryColor,
//           ledColor: AppColors.greyLight,
//         ),
//         NotificationChannel(
//           channelKey: 'call_audio',
//           channelName: 'call_audio',
//           channelDescription: 'Incoming Voice Call',
//           playSound: true,
//           onlyAlertOnce: false,
//           channelShowBadge: true,
//           groupAlertBehavior: GroupAlertBehavior.Children,
//           importance: NotificationImportance.High,
//           defaultPrivacy: NotificationPrivacy.Private,
//           defaultColor: AppColors.primaryColor,
//           ledColor: AppColors.greyLight,
//         ),
//       ],
//       debug: true,
//     );
//
//     // Get initial notification action is optional
//     initialAction = await AwesomeNotifications()
//         .getInitialNotificationAction(removeFromActionEvents: false);
//
//     await AwesomeNotifications().isNotificationAllowed().then((value) async {
//       if (!value) {
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//   }
//
//   ///  Notifications events are only delivered after call this method
//   static Future<void> initializeNotificationsEventListeners() async {
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceivedMethod,
//       onNotificationCreatedMethod: onNotificationCreatedMethod,
//       onNotificationDisplayedMethod: onNotificationDisplayedMethod,
//       onDismissActionReceivedMethod: onDismissActionReceivedMethod,
//     );
//   }
//
//   ///  *********************************************
//   ///     NOTIFICATION EVENTS
//   ///  *********************************************
//
//   /// Use this method to detect when the user taps on a notification or action button
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//     ReceivedAction receivedAction,
//   ) async {
//     // Always ensure that all plugins was initialized
//     WidgetsFlutterBinding.ensureInitialized();
//
//     bool isSilentAction =
//         receivedAction.actionType == ActionType.SilentAction ||
//             receivedAction.actionType == ActionType.SilentBackgroundAction;
//
//     if (receivedAction.actionType != ActionType.SilentBackgroundAction) {
//       debugPrint('${isSilentAction ? 'Silent action' : 'Action'} received on '
//           '${_toSimpleEnum(receivedAction.actionLifeCycle!)}');
//     }
//     switch (receivedAction.channelKey) {
//       case 'call_video':
//         print('call_video:::::');
//         if (receivedAction.actionLifeCycle != NotificationLifeCycle.AppKilled) {
//           await receiveCallNotificationAction(receivedAction);
//         }
//         break;
//       case 'call_audio':
//         print('call_audio:::::');
//         if (receivedAction.actionLifeCycle != NotificationLifeCycle.AppKilled) {
//           await receiveCallNotificationAction(receivedAction);
//         }
//         break;
//
//       case 'transcript':
//         await receiveTranscriptNotificationAction(receivedAction);
//         break;
//
//       case 'news':
//         await receiveNewsNotificationAction(receivedAction);
//         break;
//
//       case 'chats':
//         await receiveChatNotificationAction(receivedAction);
//         break;
//
//       default:
//         if (isSilentAction) {
//           debugPrint(receivedAction.toString());
//           await executeLongTaskInBackground();
//           break;
//         }
//         if (!AwesomeStringUtils.isNullOrEmpty(receivedAction.buttonKeyInput)) {
//           receiveButtonInputText(receivedAction);
//         } else {
//           receiveStandardNotificationAction(receivedAction);
//         }
//         break;
//     }
//   }
//
//   /// ***************************************************************
//   ///    NOTIFICATIONS HANDLING METHODS
//   /// ***************************************************************
//
//   static Future<void> receiveButtonInputText(
//       ReceivedAction receivedAction) async {
//     debugPrint('Input Button Message: "${receivedAction.buttonKeyInput}"');
//     // Fluttertoast.showToast(
//     //     msg: 'Msg: ${receivedAction.buttonKeyInput}',
//     //     backgroundColor: App.mainColor,
//     //     textColor: Colors.white);
//   }
//
//   static Future<void> receiveStandardNotificationAction(
//       ReceivedAction receivedAction) async {
//     // loadSingletonPage(App.navigatorKey.currentState,
//     //     targetPage: PAGE_NOTIFICATION_DETAILS, receivedAction: receivedAction);
//   }
//
//   static Future<void> receiveCallNotificationAction(
//       ReceivedAction receivedAction) async {
//     switch (receivedAction.buttonKeyPressed) {
//       case 'REJECT':
//         // Is not necessary to do anything, because the reject button is
//         // already auto dismissible
//         break;
//
//       case 'ACCEPT':
//         // loadSingletonPage(App.navigatorKey.currentState,
//         //     targetPage: PAGE_PHONE_CALL, receivedAction: receivedAction);
//         break;
//
//       default:
//         // loadSingletonPage(App.navigatorKey.currentState,
//         //     targetPage: PAGE_PHONE_CALL, receivedAction: receivedAction);
//         break;
//     }
//   }
//
//   static Future<void> receiveChatNotificationAction(
//       ReceivedAction receivedAction) async {
//     if (receivedAction.buttonKeyPressed == 'REPLY') {
//       await NotificationUtils.createMessagingNotification(
//         channelKey: 'kull_chat_app',
//         groupKey: 'kull_group_chat',
//         chatName: 'Chat Group',
//         username: 'you',
//         largeIcon: 'asset://assets/images/app_logo.png',
//         message: receivedAction.buttonKeyInput,
//       );
//     } else {
//       // loadSingletonPage(App.navigatorKey.currentState,
//       //     targetPage: PAGE_NOTIFICATION_DETAILS, receivedAction: receivedAction);
//     }
//   }
//
//   static Future<void> receiveNewsNotificationAction(
//       ReceivedAction receivedAction) async {
//     switch (receivedAction.buttonKeyPressed) {
//       case 'MEDIA_CLOSE':
//         // MediaPlayerCentral.stop();
//         break;
//
//       case 'MEDIA_PLAY':
//       case 'MEDIA_PAUSE':
//         // MediaPlayerCentral.playPause();
//         break;
//
//       case 'MEDIA_PREV':
//         // MediaPlayerCentral.previousMedia();
//         break;
//
//       case 'MEDIA_NEXT':
//         // MediaPlayerCentral.nextMedia();
//         break;
//
//       default:
//         // loadSingletonPage(App.navigatorKey.currentState,
//         //     targetPage: PAGE_MEDIA_DETAILS, receivedAction: receivedAction);
//         break;
//     }
//   }
//
//   static Future<void> receiveTranscriptNotificationAction(
//       ReceivedAction receivedAction) async {
//     if (receivedAction.buttonKeyPressed.toUpperCase() == 'TRANSCRIPT') {
//       // SharedPreferences prefs = await SharedPreferences.getInstance();
//       // prefs.setString('stringValue', "abc");
//       // await NotificationUtils.showAlarmNotification(id: receivedAction.id!);
//     }
//   }
//
//   static Future<void> interceptInitialCallActionRequest() async {
//     ReceivedAction? receivedAction =
//         await AwesomeNotifications().getInitialNotificationAction();
//
//     if (receivedAction?.channelKey == 'kull_chat_app') {
//       initialAction = receivedAction;
//     }
//   }
//
//   static String _toSimpleEnum(NotificationLifeCycle lifeCycle) =>
//       lifeCycle.toString().split('.').last;
//
//   /// Use this method to detect when a new notification or a schedule is created
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationCreatedMethod(
//     ReceivedNotification receivedNotification,
//   ) async {
//     debugPrint('Notification created on'
//         '${_toSimpleEnum(receivedNotification.createdLifeCycle!)}');
//   }
//
//   /// Use this method to detect every time that a new notification is displayed
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationDisplayedMethod(
//     ReceivedNotification receivedNotification,
//   ) async {
//     debugPrint('Notification displayed on'
//         '${_toSimpleEnum(receivedNotification.displayedLifeCycle!)}');
//   }
//
//   /// Use this method to detect if the user dismissed a notification
//   @pragma("vm:entry-point")
//   static Future<void> onDismissActionReceivedMethod(
//     ReceivedAction receivedAction,
//   ) async {
//     debugPrint('Notification dismissed on'
//         '${_toSimpleEnum(receivedAction.dismissedLifeCycle!)}');
//   }
//
//   ///  *********************************************
//   ///     REQUESTING NOTIFICATION PERMISSIONS
//   ///  *********************************************
//
//   static Future<String> requestFirebaseToken() async {
//     if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
//       try {
//         final token = await AwesomeNotificationsFcm().requestFirebaseAppToken();
//         debugPrint('FCM Token: $token');
//
//         return token;
//       } catch (exception) {
//         debugPrint('$exception');
//       }
//     } else {
//       debugPrint('Firebase is not available on this project');
//     }
//     return '';
//   }
//
//   static Future<void> checkPermission() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) {
//       await AwesomeNotifications().requestPermissionToSendNotifications();
//     }
//   }
//
//   static Future<bool> displayNotificationRationale() async {
//     bool userAuthorized = false;
//     BuildContext context = MyApp.navigatorKey.currentContext!;
//     await showDialog(
//         context: context,
//         builder: (BuildContext ctx) {
//           return AlertDialog(
//             title: Text(
//               'Get Notified!',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Image.asset(
//                         'assets/animated-bell.gif',
//                         height: MediaQuery.of(context).size.height * 0.3,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Allow Awesome Notifications to send you beautiful notifications!',
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Deny',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: Colors.red,
//                         ),
//                   )),
//               TextButton(
//                 onPressed: () async {
//                   userAuthorized = true;
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text(
//                   'Allow',
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         color: Colors.deepPurple,
//                       ),
//                 ),
//               ),
//             ],
//           );
//         });
//     return userAuthorized &&
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//   }
//
//   ///  *********************************************
//   ///     BACKGROUND TASKS TEST
//   ///  *********************************************
//   static Future<void> executeLongTaskInBackground() async {
//     print("starting long task");
//     await Future.delayed(const Duration(seconds: 4));
//     final re = await Dio().get('http://google.com');
//     print(re.data);
//     print("long task done");
//   }
//
//   ///  *********************************************
//   ///     NOTIFICATION CREATION METHODS
//   ///  *********************************************
//   ///
//   static Future<void> createNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;
//
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: -1,
//           // -1 is replaced by a random number
//           channelKey: 'alerts',
//           title: 'Huston! The eagle has landed!',
//           body:
//               "A small step for a man, but a giant leap to Flutter's community!",
//           bigPicture:
//               'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//           largeIcon:
//               'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//           //'asset://assets/images/balloons-in-sky.jpg',
//           notificationLayout: NotificationLayout.BigPicture,
//           payload: {'notificationId': '1234567890'},
//         ),
//         actionButtons: [
//           NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//           NotificationActionButton(
//             key: 'REPLY',
//             label: 'Reply Message',
//             requireInputText: true,
//             actionType: ActionType.SilentAction,
//           ),
//           NotificationActionButton(
//             key: 'DISMISS',
//             label: 'Dismiss',
//             actionType: ActionType.DismissAction,
//             isDangerousOption: true,
//           )
//         ]);
//   }
//
//   static Future<void> scheduleNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;
//
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: -1,
//         // -1 is replaced by a random number
//         channelKey: 'alerts',
//         title: "Huston! The eagle has landed!",
//         body:
//             "A small step for a man, but a giant leap to Flutter's community!",
//         bigPicture:
//             'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//         largeIcon:
//             'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//         //'asset://assets/images/balloons-in-sky.jpg',
//         notificationLayout: NotificationLayout.BigPicture,
//         payload: {'notificationId': '1234567890'},
//       ),
//       actionButtons: [
//         NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//         NotificationActionButton(
//           key: 'DISMISS',
//           label: 'Dismiss',
//           actionType: ActionType.DismissAction,
//           isDangerousOption: true,
//         )
//       ],
//       schedule: NotificationCalendar.fromDate(
//         date: DateTime.now().add(const Duration(seconds: 10)),
//       ),
//     );
//   }
//
//   static Future<void> resetBadgeCounter() async {
//     await AwesomeNotifications().resetGlobalBadge();
//   }
//
//   static Future<void> cancelNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }
// }
