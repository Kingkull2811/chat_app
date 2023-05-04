import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utilities/enum/message_type.dart';
import '../../utilities/utils.dart';

class MessageModel {
  final String? uId;
  final String? sender;
  final String? message;
  final MessageType? messageType;
  final DateTime? timestamp;

  MessageModel({
    this.uId,
    this.sender,
    this.message,
    this.messageType = MessageType.text,
    this.timestamp,
  });

  factory MessageModel.formFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MessageModel(
      uId: data?['uId'],
      sender: data?['sender'],
      message: data?['message'],
      messageType: getMessageType(data?['messesType']),
      timestamp: data?['timestamp'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uId': uId,
      'sender': sender,
      'message': message,
      'messageType': setMessageType(messageType),
      'timestamp': timestamp,
    };
  }
}
