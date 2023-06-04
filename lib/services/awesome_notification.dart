import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:chat_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AwesomeNotification {
  // init Local Notification
  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
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
      debug: debug,
    );
  }

  // init Push Notification.
  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
      // Handle Silent data
      onFcmSilentDataHandle: AwesomeNotification.mySilentDataHandle,
      onFcmTokenHandle: AwesomeNotification.myFcmTokenHandle,
      onNativeTokenHandle: AwesomeNotification.myNativeTokenHandle,

      // This license key is necessary only to remove the watermark for
      // push notifications in release mode. To know more about it, please
      // visit http://awesome-notifications.carda.me#prices
      licenseKeys: null,
      debug: debug,
    );
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
    String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'kull_chat',
        title: 'Titile Notification',
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
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    // final re = await http.get(url);
    // print(re.body);
    if (kDebugMode) {
      print("long task done");
    }
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
}
