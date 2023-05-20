import 'package:chat_app/network/model/chat_model.dart';
import 'package:chat_app/screens/chats/chat_room/message_view.dart';
import 'package:chat_app/screens/chats/tab/new_message.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../network/model/user_from_firebase.dart';
import '../../../services/firebase_services.dart';
import '../../../theme.dart';
import '../../../utilities/shared_preferences_storage.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';

class ChatTab extends StatefulWidget {
  final List<UserFirebaseData>? listUser;

  const ChatTab({Key? key, this.listUser}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final int currentUserId = SharedPreferencesStorage().getUserId();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ChatModel> convertListChat(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
  ) {
    List<ChatModel> listChat = [];
    final data = snapshot.data?.docs;
    for (var doc in data!) {
      if (doc.exists) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> userId = docData['members'];
        Map<String, dynamic> names = docData['names'];
        Map<String, dynamic> imageUrls = docData['imageUrls'];
        userId.remove('$currentUserId');
        names.remove('$currentUserId');
        imageUrls.remove('$currentUserId');

        final Map<String, dynamic> mapDoc = {
          "receiver_id": userId.keys.first,
          "receiver_avt": imageUrls.values.first,
          "receiver_name": names.values.first,
          "last_message": docData['last_message'],
          "message_type": docData['message_type'],
          "time": docData['time']
        };

        listChat.add(ChatModel.fromJson(mapDoc));
      }
    }
    return listChat;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService().getListChat(currentUserId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AnimationLoading();
        }

        if (snapshot.hasData) {
          List<ChatModel> listChat = convertListChat(snapshot);
          return _listChat(listChat);
        } else {
          return const Center(
            child: Text(
              'no messages yet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _listChat(List<ChatModel>? listChat) {
    return Scaffold(
      body: isNullOrEmpty(listChat)
          ? const Center(
              child: Text(
                'no messages yet',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemCount: listChat!.length,
              itemBuilder: (context, index) =>
                  _itemChat(context, listChat[index]),
            ),
      floatingActionButton: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewMessage(listUser: widget.listUser),
            ),
          );
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.primaryColor,
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

  _navToChatRoom(ChatModel chatItem) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageView(
            receiverId: chatItem.receiverId ?? '',
            receiverName: chatItem.receiverName ?? '',
            receiverAvt: chatItem.receiverAvt ?? '',
          ),
        ),
      );

  Widget _itemChat(BuildContext context, ChatModel chatItem) {
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
        child: ListTile(
          onTap: () {
            _navToChatRoom(chatItem);
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                width: 1,
                color: AppColors.primaryColor,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: AppImage(
                isOnline: true,
                localPathOrUrl: chatItem.receiverAvt,
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
                  chatItem.receiverName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Text(
                formatDateUtcToTime(chatItem.time),
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
                  child: Text(
                    chatItem.lastMessage ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 10),
                //   child: Icon(
                //     isRead ? Icons.check_circle : Icons.check_circle_outline,
                //     size: 16,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
