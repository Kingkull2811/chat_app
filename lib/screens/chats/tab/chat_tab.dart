import 'package:badges/badges.dart';
import 'package:chat_app/screens/chats/chat_room/chat_room.dart';
import 'package:chat_app/utilities/enum/message_type.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../network/model/message_model.dart';
import '../../../services/firebase_services.dart';
import '../../../utilities/shared_preferences_storage.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  bool isRead = false;

  Map<String, String> mapDocIdReceiverId = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService().getAllMessage(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const AnimationLoading();
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const AnimationLoading();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'no messages yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              } else {
                List<MessageModel> listMessage = [];
                final data = snapshot.data?.docs;

                for (var doc in data!) {
                  if (doc.exists) {
                    if (doc.data() is Map<String, dynamic>) {
                      final int userID = SharedPreferencesStorage().getUserId();
                      final message = MessageModel.fromJson(
                          doc.data() as Map<String, dynamic>);
                      if (message.fromId == userID || message.toId == userID) {
                        mapDocIdReceiverId[
                            '${message.fromId}-${message.toId}'] = doc.id;
                        listMessage.add(message);
                      }
                    }
                  }
                }
                return _listChat(listMessage);
              }
          }
        }
      },
    );
  }

  Widget _listChat(List<MessageModel> listMessage) {
    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: listMessage.length,
        itemBuilder: (context, index) => _itemChat(context, listMessage[index]),
      ),
      floatingActionButton: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {},
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).primaryColor,
          ),
          child: const Icon(
            Icons.add,
            size: 36,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _navToNewChat() {}

  _navToChatRoom(MessageModel messageData, String docId) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoom(
            messageData: messageData,
            docID: docId,
          ),
        ),
      );

  Widget _itemChat(BuildContext context, MessageModel message) {
    final isMe = message.fromId == SharedPreferencesStorage().getUserId();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        child: Badge(
          showBadge: false, //(messageData.messageNum ?? 0) > 0,
          badgeContent: Text(
            message.messageNum.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          badgeStyle: const BadgeStyle(
            badgeColor: Colors.red,
            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
          ),
          position: BadgePosition.topEnd(top: 0, end: 0),
          child: ListTile(
            onTap: () {
              _navToChatRoom(
                message,
                mapDocIdReceiverId['${message.fromId}-${message.toId}'] ?? '',
              );
            },
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: AppImage(
                  isOnline: true,
                  localPathOrUrl: isMe ? message.toAvatar : message.fromAvatar,
                  boxFit: BoxFit.cover,
                  errorWidget: Container(
                    color: Colors.grey.withOpacity(0.2),
                    child: const Icon(
                      Icons.person_outline,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isMe ? (message.toName ?? '') : (message.fromName ?? ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Text(
                  formatDateUtcToTime(message.lastTime),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: message.messageType == MessageType.image
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(
                                CupertinoIcons.photo,
                                size: 10,
                                color: Colors.grey,
                              ),
                              Text(
                                ' photo',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          )
                        : Text(
                            message.lastMessage ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      isRead ? Icons.check_circle : Icons.check_circle_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _messageItem(
  //     BuildContext context,
  //     MessageModel message,
  //     ) {
  //   final isMe = message.fromId == SharedPreferencesStorage().getUserId();
  //   Widget messageContain(MessageContentModel itemMessage) {
  //     switch (itemMessage.messageType) {
  //       case MessageType.text:
  //         return textMessage(itemMessage, isMe);
  //
  //       case MessageType.image:
  //         return imageMessage(itemMessage, isMe);
  //
  //       case MessageType.video:
  //         return videoMessage(itemMessage, isMe);
  //
  //       case MessageType.audio:
  //         return audioMessage(itemMessage, isMe);
  //
  //       default:
  //         return const SizedBox();
  //     }
  //   }
  //
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Column(
  //       crossAxisAlignment:
  //       isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //       children: [
  //         // Padding(
  //         //   padding: const EdgeInsets.only(top: 6, bottom: 0),
  //         //   child: Center(
  //         //     child: Text(
  //         //       formatDateUtcToTime(message.time),
  //         //       style: TextStyle(
  //         //           fontSize: 14,
  //         //           fontWeight: FontWeight.normal,
  //         //           color: Theme.of(context).primaryColor),
  //         //     ),
  //         //   ),
  //         // ),
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
  //           child: messageContain(message),
  //         ),
  //         Text(
  //           formatDateUtcToTime(message.time),
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.normal,
  //             color: Theme.of(context).primaryColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
