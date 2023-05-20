import 'package:chat_app/utilities/enum/message_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utilities/utils.dart';

class ChatModel {
  final String? receiverId;
  final String? receiverAvt;
  final String? receiverName;
  final String? lastMessage;
  final MessageType? messageType;
  final Timestamp? time;

  ChatModel({
    this.receiverId,
    this.receiverAvt,
    this.receiverName,
    this.lastMessage,
    this.messageType,
    this.time,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      receiverId: json['receiver_id'],
      receiverAvt: json['receiver_avt'],
      receiverName: json['receiver_name'],
      lastMessage: json['last_message'],
      messageType: getMessageType(json['messes_type']),
      time: json['time'],
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
}

class Member {
  final int? currentId;
  final int? receiverId;

  Member({
    this.currentId,
    this.receiverId,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      currentId: json['currentId'],
      receiverId: json['receiverId'],
    );
  }
}
