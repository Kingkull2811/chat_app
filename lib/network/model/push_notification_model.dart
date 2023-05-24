class PushNotification {
  final String? title, body;

  PushNotification({this.title, this.body});

  Map<String, dynamic> toJson() => {'title': title, 'body': body};
}
