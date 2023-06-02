import 'package:chat_app/network/provider/push_notification_provider.dart';

class PushNotificationRepository {
  final _pushProvider = PushNotificationProvider();

  Future messagePN({required Map<String, dynamic> data}) async =>
      await _pushProvider.pushNotification(data: data);
}
