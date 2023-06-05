import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:chat_app/routes.dart';
import 'package:chat_app/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../utilities/notifications_util.dart';
import '../utilities/utils.dart';

class AwesomeNotification {
  static final AwesomeNotification _instance = AwesomeNotification._internal();

  factory AwesomeNotification() {
    return _instance;
  }

  AwesomeNotification._internal();

  static ReceivedAction? initialCallAction;

  // init Local Notification
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null, // 'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'kull_chat',
          channelName: 'kull_chat',
          channelDescription: 'Notification tests as alerts',
          playSound: true,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: AppColors.primaryColor,
          ledColor: Colors.white,
        )
      ],
      debug: true,
    );
  }

  // init Push Notification.
  static Future<void> initializeRemoteNotifications() async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
      onFcmSilentDataHandle: AwesomeNotification.mySilentDataHandle,
      onFcmTokenHandle: AwesomeNotification.myFcmTokenHandle,
      onNativeTokenHandle: AwesomeNotification.myNativeTokenHandle,
      licenseKeys: null,
      debug: true,
    );
  }

  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: AwesomeNotification.onActionReceivedMethod,
      onNotificationCreatedMethod:
          AwesomeNotification.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          AwesomeNotification.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          AwesomeNotification.onDismissActionReceivedMethod,
    );
  }

  static Future<void> interceptInitialCallActionRequest() async {
    ReceivedAction? receivedAction =
        await AwesomeNotifications().getInitialNotificationAction();

    if (receivedAction?.channelKey == 'call_channel') {
      initialCallAction = receivedAction;
    }
  }

  //get device FCM Token
  Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        final token = await AwesomeNotificationsFcm().requestFirebaseAppToken();
        if (kDebugMode) {
          print('==================FCM Token==================');
          print(token);
          print('======================================');
        }

        return token;
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }

  Future<void> checkPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> localNotification() async {
    // String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'kull_chat',
        title: 'Title Notification',
        body: 'Content Notification',
        notificationLayout: NotificationLayout.Messaging,
      ),
    );
  }

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    if (kDebugMode) {
      print('"SilentData": ${silentData.toString()}');
    }

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      if (kDebugMode) {
        print("bg");
      }
    } else {
      if (kDebugMode) {
        print("FOREGROUND");
      }
    }

    if (kDebugMode) {
      print("starting long task");
    }
    // await Future.delayed(const Duration(seconds: 4));
    // final url = Uri.parse("http://google.com");
    // final re = await http.get(url);
    // print(re.body);
    // if (kDebugMode) {
    //   print("long task done");
    // }
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    // debugPrint('FCM Token:"$token"');
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    // debugPrint('Native Token:"$token"');
  }

  // ***************************************************************
  //    NOTIFICATIONS EVENT LISTENERS
  // ***************************************************************

  static String _toSimpleEnum(NotificationLifeCycle lifeCycle) =>
      lifeCycle.toString().split('.').last;

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Fluttertoast.showToast(
    //   msg:
    //       'Notification created on ${_toSimpleEnum(receivedNotification.createdLifeCycle!)}',
    //   toastLength: Toast.LENGTH_SHORT,
    //   backgroundColor: Colors.green,
    //   gravity: ToastGravity.BOTTOM,
    // );
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Fluttertoast.showToast(
    //   msg:
    //       'Notification displayed on ${_toSimpleEnum(receivedNotification.displayedLifeCycle!)}',
    //   toastLength: Toast.LENGTH_SHORT,
    //   backgroundColor: Colors.blue,
    //   gravity: ToastGravity.BOTTOM,
    // );
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Fluttertoast.showToast(
    //   msg:
    //       'Notification dismissed on ${_toSimpleEnum(receivedAction.dismissedLifeCycle!)}',
    //   toastLength: Toast.LENGTH_SHORT,
    //   backgroundColor: Colors.orange,
    //   gravity: ToastGravity.BOTTOM,
    // );
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();

    bool isSilentAction =
        receivedAction.actionType == ActionType.SilentAction ||
            receivedAction.actionType == ActionType.SilentBackgroundAction;

    // SilentBackgroundAction runs on background thread and cannot show
    // UI/visual elements
    if (receivedAction.actionType != ActionType.SilentBackgroundAction) {
      Fluttertoast.showToast(
        msg:
            '${isSilentAction ? 'Silent action' : 'Action'} received on ${_toSimpleEnum(receivedAction.actionLifeCycle!)}',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor:
            isSilentAction ? Colors.blueAccent : AppColors.primaryColor,
        gravity: ToastGravity.BOTTOM,
      );
    }

    switch (receivedAction.channelKey) {
      case 'call_channel':
        if (receivedAction.actionLifeCycle != NotificationLifeCycle.AppKilled) {
          await receiveCallNotificationAction(receivedAction);
        }
        break;

      case 'alarm_channel':
        // await receiveAlarmNotificationAction(receivedAction);
        break;

      case 'media_player':
        // await receiveMediaNotificationAction(receivedAction);
        break;

      case 'chats':
        await receiveChatNotificationAction(receivedAction);
        break;

      default:
        if (isSilentAction) {
          debugPrint(receivedAction.toString());
          debugPrint("start");
          await Future.delayed(const Duration(seconds: 4));
          final re = await Dio().get("http://google.com");
          debugPrint(re.data);
          debugPrint("long task done");
          break;
        }
        if (!AwesomeStringUtils.isNullOrEmpty(receivedAction.buttonKeyInput)) {
          receiveButtonInputText(receivedAction);
        } else {
          receiveStandardNotificationAction(receivedAction);
        }
        break;
    }
  }

  static Future<void> receiveButtonInputText(
      ReceivedAction receivedAction) async {
    debugPrint('Input Button Message: "${receivedAction.buttonKeyInput}"');
    // Fluttertoast.showToast(
    //   msg: 'Msg: ${receivedAction.buttonKeyInput}',
    //   backgroundColor: AppColors.primaryColor,
    //   textColor: Colors.white,
    // );
  }

  static Future<void> receiveStandardNotificationAction(
      ReceivedAction receivedAction) async {
    // loadSingletonPage(
    //   MyApp.navigatorKey.currentState,
    //   targetPage: PAGE_NOTIFICATION_DETAILS,
    //   receivedAction: receivedAction,
    // );
  }

  static Future<void> receiveChatNotificationAction(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'REPLY') {
      await NotificationUtils.createMessagingNotification(
        channelKey: 'chats',
        groupKey: 'jhonny_group',
        chatName: 'Jhonny\'s Group',
        username: 'you',
        largeIcon: 'asset://assets/images/rock-disc.jpg',
        message: receivedAction.buttonKeyInput,
      );
    } else {
      // loadSingletonPage(MyApp.navigatorKey.currentState,
      //     targetPage: PAGE_NOTIFICATION_DETAILS, receivedAction: receivedAction);
    }
  }

  static Future<void> receiveCallNotificationAction(
      ReceivedAction receivedAction) async {
    switch (receivedAction.buttonKeyPressed) {
      case 'REJECT':
        // Is not necessary to do anything, because the reject button is
        // already auto dismissible
        break;

      case 'ACCEPT':
        loadSingletonPage(
          MyApp.navigatorKey.currentState,
          targetPage: AppRoutes.callPage,
          receivedAction: receivedAction,
        );
        break;

      default:
        loadSingletonPage(
          MyApp.navigatorKey.currentState,
          targetPage: AppRoutes.callPage,
          receivedAction: receivedAction,
        );
        break;
    }
  }
}
