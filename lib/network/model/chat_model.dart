import 'package:chat_app/utilities/enum/message_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utilities/utils.dart';

class ChatModel {
  final String receiverId;
  final String receiverAvt;
  final String receiverName;
  final String lastMessage;
  final MessageType messageType;
  final Timestamp time;
  final String receiverFcmToken;

  ChatModel({
    required this.receiverId,
    required this.receiverAvt,
    required this.receiverName,
    required this.lastMessage,
    required this.messageType,
    required this.time,
    required this.receiverFcmToken,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      receiverId: json['receiver_id'],
      receiverAvt: json['receiver_avt'],
      receiverName: json['receiver_name'],
      lastMessage: json['last_message'],
      messageType: getMessageType(json['messes_type']),
      time: json['time'],
      receiverFcmToken: json['fcm_token'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "receiver_id": receiverId,
      "receiver_avt": receiverAvt,
      "receiver_name": receiverName,
      "last_message": lastMessage,
      "message_type": setMessageType(messageType),
      "time": time
    };
  }

  @override
  String toString() {
    return 'ChatModel{receiverId: $receiverId, receiverName: $receiverName, lastMessage: $lastMessage, messageType: $messageType, time: $time,}';
  }
}
