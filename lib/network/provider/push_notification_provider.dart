import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:dio/dio.dart';

class PushNotificationProvider with ProviderMixin {
  Future pushNotification(
      // Map<String, dynamic> data,
      String fcmToken,
      title,
      message) async {
    try {
      print('receiver fcmToken: $fcmToken');
      var data = {
        'to': fcmToken,
        'notification': {
          'title': title,
          'body': message,
          "sound": "jetsons_doorbell.mp3"
        },
        'android': {
          'notification': {
            'notification_count': 3,
          },
        },
        'data': {'type': 'kull_chat', 'id': 'Test doc ID'}
      };

      final response = await dio.post(
        // ApiPath.fcmServer,
        'https://fcm.googleapis.com/fcm/send',
        data: jsonEncode(data),
        // queryParameters: {
        //   'Content-Type': 'application/json; charset=UTF-8',
        //   'Authorization': AppConstants.fcmTokenServerKey,
        // },
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'key=${AppConstants.fcmTokenServerKey}'
          },
        ),
      );

      log('rs: ${response.data}');
      return response.data;
      // return PushNotificationResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, ApiPath.fcmServer);
    }
  }
}
