import 'package:badges/badges.dart';
import 'package:chat_app/screens/chats/chat_room/chat_room.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../network/model/message_model.dart';
import '../../../services/firebase_services.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _searchController = TextEditingController();

  bool _showSearchResult = false;

  bool isRead = false;

  Map<int, String> mapDocIdReceiverId = {};

  @override
  void initState() {
    _searchController.addListener(() {
      _showSearchResult = _searchController.text.isNotEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService().getListChatByUserID(),
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
                      final message = MessageModel.fromJson(
                          doc.data() as Map<String, dynamic>);
                      mapDocIdReceiverId[message.toId!] = doc.id;
                      listMessage.add(message);
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

  Widget _itemChat(BuildContext context, MessageModel messageData) {
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
            messageData.messageNum.toString(),
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
                messageData,
                mapDocIdReceiverId[messageData.toId] ?? '',
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
                  localPathOrUrl: messageData.toAvatar,
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
                Text(
                  messageData.toName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    formatDateUtcToTime(messageData.lastTime),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
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
                  Text(
                    messageData.lastMessage ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
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
}
