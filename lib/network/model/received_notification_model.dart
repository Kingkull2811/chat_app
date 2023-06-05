class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });

  @override
  String toString() {
    return 'ReceivedNotification{id: $id, title: $title, body: $body, payload: $payload}';
  }
}
