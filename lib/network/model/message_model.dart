import 'package:chat_app/utilities/enum/message_type.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final int? fromId;
  final String? message;
  final MessageType? messageType;
  final Timestamp? time;

  MessageModel({
    this.fromId,
    this.message,
    this.messageType,
    this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        fromId: int.parse(json['from_id'].toString()),
        message: json['message'],
        messageType: getMessageType(json['message_type']),
        time: json['time'],
      );
  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MessageModel(
      fromId: data?['from_id'],
      message: data?['message'],
      messageType: getMessageType(data?['message_type']),
      time: data?['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_id': fromId,
      'message': message,
      'message_type': setMessageType(messageType),
      'time': time
    };
  }

  @override
  String toString() {
    return 'MessageModel{fromId: $fromId, message: $message, messageType: $messageType, time: $time}';
  }
}
