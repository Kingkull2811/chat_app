import 'dart:convert';

import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:dio/dio.dart';

class PushNotificationProvider with ProviderMixin {
  Future pushNotification({required Map<String, dynamic> data}) async {
    try {
      return await dio.post(
        ApiPath.fcmServer,
        // 'https://fcm.googleapis.com/fcm/send',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'key=${AppConstants.fcmTokenServerKey}'
          },
        ),
      );
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, ApiPath.fcmServer);
    }
  }
}
