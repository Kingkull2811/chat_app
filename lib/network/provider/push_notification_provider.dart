import 'dart:developer';

import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';

import '../response/push_notification_response.dart';

class PushNotificationProvider with ProviderMixin {
  Future pushNotification(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        ApiPath.fcmServer,
        data: data,
        // queryParameters: {
        //   'Content-Type': 'application/json',
        //   'Authorization': AppConstants.fcmTokenServerKey,
        // },
        options: optionsToFCMServer(),
      );

      log('rs: ${response.data}');

      return PushNotificationResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorResponse(error, stacktrace, ApiPath.fcmServer);
    }
  }
}
