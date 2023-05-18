import '../../utilities/enum/message_type.dart';
import '../../utilities/utils.dart';

class MessageModel {
  final int? fromId;
  final String? fromName;
  final String? fromAvatar;
  final int? toId;
  final String? toName;
  final String? toAvatar;
  final String? sent;
  final String? read;
  final String? lastMessage;
  final MessageType? messageType;
  final DateTime? lastTime;
  final int? messageNum;

  MessageModel({
    this.fromId,
    this.fromName,
    this.fromAvatar,
    this.toId,
    this.toName,
    this.toAvatar,
    this.sent,
    this.read,
    this.lastMessage,
    this.messageType = MessageType.text,
    this.lastTime,
    this.messageNum,
  });

  factory MessageModel.formJson(Map<String, dynamic> json) => MessageModel(
        fromId: json['from_id'],
        fromName: json['from_name'],
        fromAvatar: json['from_avatar'],
        toId: json['to_id'],
        toName: json['to_name'],
        toAvatar: json['to_avatar'],
        read: json['read'],
        sent: json['sent'],
        lastMessage: json['message'],
        messageType: getMessageType(json['messes_type']),
        lastTime: json['timestamp'],
        messageNum: json['message_num'],
      );

  Map<String, dynamic> toFirestore() {
    return {
      'from_id': fromId,
      'from_name': fromName,
      'from_avatar': fromAvatar,
      'to_id': toId,
      'to_name': toName,
      'to_avatar': toAvatar,
      'sent': sent,
      'read': read,
      'message': lastMessage,
      'messageType': setMessageType(messageType),
      'timestamp': lastTime,
      'message_num': messageNum,
    };
  }
}
