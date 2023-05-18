import 'package:chat_app/network/model/message_content_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatRoomEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMessage extends ChatRoomEvent {
  final String docId;

  GetMessage(this.docId);

  @override
  List<Object?> get props => [docId];
}

class AddMessage extends ChatRoomEvent {
  final MessageContentModel messageContent;
  final String docID;

  AddMessage({required this.messageContent, required this.docID});
  @override
  List<Object?> get props => [messageContent, docID];
}
