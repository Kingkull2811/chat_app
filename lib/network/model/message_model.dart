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

  factory MessageModel.formJson(Map<String, dynamic> json) => MessageModel(
        uId: json['uId'],
        sender: json['sender'],
        message: json['message'],
        messageType: getMessageType(json['messesType']),
        timestamp: json['timestamp'],
      );

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
