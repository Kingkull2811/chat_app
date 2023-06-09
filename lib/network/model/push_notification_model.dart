class PushNotification {
  final String to;
  final NotificationData notification;
  final PushNotificationData data;
  final bool contentAvailable;
  final String priority;

  PushNotification({
    required this.to,
    required this.notification,
    required this.data,
    required this.contentAvailable,
    required this.priority,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      to: json['to'] as String,
      notification: NotificationData.fromJson(
          json['notification'] as Map<String, dynamic>),
      data: PushNotificationData.fromJson(json['data'] as Map<String, dynamic>),
      contentAvailable: json['content_available'] as bool,
      priority: json['priority'] as String,
    );
  }

  @override
  String toString() {
    return 'PushNotification{to: $to, notification: $notification, data: $data, contentAvailable: $contentAvailable, priority: $priority}';
  }
}

class NotificationData {
  final String body;
  final String title;
  final bool sound;

  NotificationData({
    required this.body,
    required this.title,
    required this.sound,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      body: json['body'] as String,
      title: json['title'] as String,
      sound: json['sound'] as bool,
    );
  }

  @override
  String toString() {
    return 'NotificationData{body: $body, title: $title, sound: $sound}';
  }
}

class PushNotificationData {
  final String contentType;
  final int value;

  PushNotificationData({
    required this.contentType,
    required this.value,
  });

  factory PushNotificationData.fromJson(Map<String, dynamic> json) {
    return PushNotificationData(
      contentType: json['content_type'] as String,
      value: json['value'] as int,
    );
  }

  @override
  String toString() {
    return 'PushNotificationData{contentType: $contentType, value: $value}';
  }
}
