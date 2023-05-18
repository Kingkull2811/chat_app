import 'package:chat_app/network/model/message_content_model.dart';
import 'package:chat_app/network/model/message_model.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/utilities/enum/message_type.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/custom_app_bar_chat.dart';
import 'package:chat_app/widgets/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utilities/utils.dart';
import '../../../widgets/app_image.dart';

class ChatRoom extends StatefulWidget {
  final MessageModel messageData;
  final String docID;

  const ChatRoom({
    Key? key,
    required this.messageData,
    required this.docID,
  }) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _inputTextController = TextEditingController();
  bool _showIconSend = false;
  bool _showEmoji = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _inputTextController.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _showIconSend = _inputTextController.text.isNotEmpty;
    });
  }

  void _scrollToEnd() {
    Future.delayed(Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBarChat(
          title: widget.messageData.toName ?? '',
          image: widget.messageData.toAvatar ?? '',
          onTapLeadingIcon: () {
            Navigator.pop(context);
          },
        ),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: <Widget>[
            Expanded(
              child: _bodyChat(),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _bodyChat() {
    return StreamBuilder(
      stream: FirebaseService().getListMessageInChatRoom(widget.docID),
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
                return _helloMessage();
              } else {
                List<MessageContentModel> listMessageContent = [];
                final data = snapshot.data?.docs;

                for (var doc in data!) {
                  if (doc.exists) {
                    if (doc.data() is Map<String, dynamic>) {
                      final message = MessageContentModel.fromJson(
                        doc.data() as Map<String, dynamic>,
                      );
                      listMessageContent.add(message);
                    }
                  }
                }
                _scrollToEnd();
                return _listMessage(listMessageContent);
              }
          }
        }
      },
    );
  }

  Widget _listMessage(List<MessageContentModel>? listMessage) {
    if (isNullOrEmpty(listMessage)) {
      return _helloMessage();
    } else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: listMessage!.length,
        itemBuilder: (context, index) {
          return _chatItem(context, listMessage[index]);
        },
      );
    }
  }

  Widget _helloMessage() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      child: Column(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.5,
                  color: Theme.of(context).primaryColor,
                )
                // borderRadius: BorderRadius.circular(50),
                ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: AppImage(
                isOnline: true,
                localPathOrUrl: widget.messageData.toAvatar,
                boxFit: BoxFit.cover,
                errorWidget: const Icon(
                  CupertinoIcons.person,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              widget.messageData.toName ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Say hi 👋 to start chat with @${widget.messageData.toName}',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: BorderDirectional(
          top: BorderSide(width: 0.3, color: Colors.grey.withOpacity(0.05)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              iconSize: 30,
              icon: Icon(
                Icons.image_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                constraints: const BoxConstraints(
                  maxHeight: 40,
                  // maxHeight: 50,
                  // minHeight: 34,
                ),
                child: TextFormField(
                  onTap: () {},
                  controller: _inputTextController,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 16),
                    hintText: 'Aa',
                    hintStyle: TextStyle(
                      color: Colors.grey[250],
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        //handle emoji
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      child: Icon(
                        Icons.emoji_emotions_outlined,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    suffixIconColor: Theme.of(context).primaryColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _showIconSend
                ? IconButton(
                    iconSize: 30,
                    onPressed: () async {
                      if (_inputTextController.text.isNotEmpty) {
                        MessageContentModel message = MessageContentModel(
                          fromId: widget.messageData.fromId,
                          message: _inputTextController.text.trim(),
                          messageType: MessageType.text,
                          time: Timestamp.now(),
                        );
                        await FirebaseService()
                            .sendMessageToFirebase(widget.docID, message);
                        _inputTextController.clear();
                      }
                    },
                    icon: Icon(
                      Icons.send_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : IconButton(
                    iconSize: 30,
                    onPressed: () {
                      if (_inputTextController.text.isNotEmpty) {}
                    },
                    icon: Icon(
                      Icons.mic_none_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _chatItem(
    BuildContext context,
    MessageContentModel message,
  ) {
    final isMe = message.fromId == SharedPreferencesStorage().getUserId();
    Widget messageContain(MessageContentModel itemMessage) {
      switch (itemMessage.messageType) {
        case MessageType.text:
          return textMessage(itemMessage, isMe);

        case MessageType.image:
          return imageMessage(itemMessage, isMe);

        case MessageType.video:
          return videoMessage(itemMessage, isMe);

        case MessageType.audio:
          return audioMessage(itemMessage, isMe);

        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 6, bottom: 0),
          //   child: Center(
          //     child: Text(
          //       formatDateUtcToTime(message.time),
          //       style: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.normal,
          //           color: Theme.of(context).primaryColor),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: messageContain(message),
          ),
          Text(
            formatDateUtcToTime(message.time),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }

  Widget textMessage(MessageContentModel message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[100] : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(10),
          topLeft: const Radius.circular(10),
          bottomRight:
              isMe ? const Radius.circular(0) : const Radius.circular(10),
          bottomLeft:
              isMe ? const Radius.circular(10) : const Radius.circular(0),
        ),
      ),
      child: Text(
        message.message ?? '',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget imageMessage(MessageContentModel itemMessage, bool isMe) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PhotoViewPage(imageUrl: itemMessage.message),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppImage(
              isOnline: true,
              localPathOrUrl: itemMessage.message,
              boxFit: BoxFit.cover,
              errorWidget: Icon(
                Icons.image_outlined,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget videoMessage(MessageContentModel itemMessage, bool isMe) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AppImage(
                  isOnline: true,
                  localPathOrUrl: itemMessage.message,
                  boxFit: BoxFit.cover,
                  errorWidget: Icon(
                    Icons.image_outlined,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget audioMessage(MessageContentModel itemMessage, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[100] : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(10),
          topLeft: const Radius.circular(10),
          bottomRight:
              isMe ? const Radius.circular(0) : const Radius.circular(10),
          bottomLeft:
              isMe ? const Radius.circular(10) : const Radius.circular(0),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Row(
          children: [
            Icon(
              Icons.play_arrow,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey[600]?.withOpacity(0.4),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                '0:49',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
