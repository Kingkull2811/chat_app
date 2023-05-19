import 'dart:io';

import 'package:chat_app/network/model/message_content_model.dart';
import 'package:chat_app/network/model/message_model.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/enum/message_type.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../network/model/user_from_firebase.dart';
import '../../../theme.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/app_image.dart';
import '../chat_info/chat_info.dart';

class ChatRoom extends StatefulWidget {
  final MessageModel? messageData;
  final String? docID;

  final bool isNewMessage;
  final UserFirebaseData? receiver;

  const ChatRoom({
    Key? key,
    this.messageData,
    this.docID,
    this.isNewMessage = false,
    this.receiver,
  }) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _inputTextController = TextEditingController();

  bool _isMe = false;
  bool _isNewMessage = false;

  final ScrollController _scrollController = ScrollController();

  String docID = '';

  @override
  void initState() {
    _isMe =
        widget.messageData?.fromId == SharedPreferencesStorage().getUserId();
    docID = widget.docID ?? '';
    _isNewMessage = widget.isNewMessage;
    super.initState();
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 0), () {
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent + 500);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Theme.of(context).primaryColor,
          leadingWidth: 30,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: AppImage(
                    isOnline: true,
                    localPathOrUrl: widget.isNewMessage
                        ? widget.receiver?.fileUrl
                        : _isMe
                            ? widget.messageData?.toAvatar
                            : widget.messageData?.fromAvatar,
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
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  (widget.isNewMessage
                          ? widget.receiver?.fullName
                          : _isMe
                              ? widget.messageData?.toName
                              : widget.messageData?.fromName) ??
                      '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                size: 24,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatInfoPage(
                      name: (widget.isNewMessage
                              ? widget.receiver?.fullName
                              : _isMe
                                  ? widget.messageData?.toName
                                  : widget.messageData?.fromName) ??
                          '',
                      imageUrl: widget.isNewMessage
                          ? widget.receiver?.fileUrl
                          : _isMe
                              ? widget.messageData?.toAvatar
                              : widget.messageData?.fromAvatar,
                      isGroup: false,
                      receiverID: (widget.isNewMessage
                          ? widget.receiver?.id
                          : _isMe
                              ? widget.messageData?.toId
                              : widget.messageData?.fromId)!,
                    ),
                  ),
                );
                // Add the action you want to perform when the icon is tapped
              },
            ),
          ],
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
    List<MessageContentModel> listMessageContent = [];
    return _isNewMessage
        ? Container(
            child: _listMessage(listMessageContent),
          )
        : StreamBuilder(
            stream: FirebaseService().getListMessageInChatRoom(docID),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      _scrollToEnd();

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
                  color: AppColors.primaryColor,
                )
                // borderRadius: BorderRadius.circular(50),
                ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: AppImage(
                isOnline: true,
                localPathOrUrl: widget.isNewMessage
                    ? widget.receiver?.fileUrl
                    : widget.messageData?.toAvatar,
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
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              (widget.isNewMessage
                      ? widget.receiver?.fullName
                      : widget.messageData?.toName) ??
                  '',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Say hi 👋 to start chat with @${widget.isNewMessage ? widget.receiver?.fullName : widget.messageData?.toName}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: AppColors.primaryColor,
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
        color: AppColors.primaryColor.withOpacity(0.1),
        border: BorderDirectional(
          top: BorderSide(width: 0.3, color: Colors.grey.withOpacity(0.05)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                _pickImageToSend(context);
              },
              iconSize: 30,
              icon: const Icon(
                Icons.image_outlined,
                color: AppColors.primaryColor,
              ),
            ),
            IconButton(
              iconSize: 30,
              onPressed: () {},
              icon: const Icon(
                Icons.mic_none_outlined,
                color: AppColors.primaryColor,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                constraints: const BoxConstraints(
                  maxHeight: 40,
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
                      onTap: () {},
                      child: const Icon(
                        Icons.emoji_emotions_outlined,
                        size: 24,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    suffixIconColor: AppColors.primaryColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        width: 1,
                        color: AppColors.primaryColor,
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
            IconButton(
              iconSize: 30,
              onPressed: () async {
                await _sendTextMessage();
              },
              icon: const Icon(
                Icons.send_outlined,
                color: AppColors.primaryColor,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: messageContain(message),
          ),
          Text(
            formatDateUtcToTime(message.time),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget textMessage(MessageContentModel message, bool isMe) {
    return Padding(
      padding: EdgeInsets.only(left: isMe ? 50.0 : 0, right: isMe ? 0 : 50),
      child: Container(
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
              errorWidget: const Icon(
                Icons.image_outlined,
                size: 50,
                color: AppColors.primaryColor,
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
                  errorWidget: const Icon(
                    Icons.image_outlined,
                    size: 50,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
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
            const Icon(
              Icons.play_arrow,
              color: AppColors.primaryColor,
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

  Future<void> _sendTextMessage() async {
    if (_inputTextController.text.isNotEmpty) {
      MessageContentModel message = MessageContentModel(
        fromId: SharedPreferencesStorage().getUserId(),
        message: _inputTextController.text.trim(),
        messageType: MessageType.text,
        time: Timestamp.now(),
      );
      if (_isNewMessage) {
        MessageModel messageModel = MessageModel(
          fromId: SharedPreferencesStorage().getUserId(),
          fromAvatar: SharedPreferencesStorage().getImageAvartarUrl(),
          //todo
          fromName: "SharedPreferencesStorage().getFullName()",
          lastMessage: _inputTextController.text.trim(),
          messageType: MessageType.text,
          lastTime: Timestamp.now(),
          toId: widget.receiver?.id,
          toName: widget.receiver?.fullName,
          toAvatar: widget.receiver?.fileUrl,
          sent: 'f',
          read: 'ff',
        );
      } else {
        await FirebaseService().sendMessageToFirebase(docID, message);
      }
      _inputTextController.clear();
    }
  }

  Future<void> _sendMessageImage(String? imagePath) async {
    if (imagePath != null) {
      MessageContentModel message = MessageContentModel(
        fromId: SharedPreferencesStorage().getUserId(),
        message: await FirebaseService().uploadImageToStorage(
          titleName: 'image_message',
          childFolder: AppConstants.imageMessageChild,
          image: File(imagePath),
        ),
        messageType: MessageType.image,
        time: Timestamp.now(),
      );
      await FirebaseService().sendMessageToFirebase(
        docID,
        message,
      );
    }
  }

  _pickImageToSend(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                String? imagePath = await pickPhoto(ImageSource.camera);
                await _sendMessageImage(imagePath);
              },
              child: const Text(
                'Take a photo from camera',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                String? imagePath = await pickPhoto(ImageSource.gallery);
                await _sendMessageImage(imagePath);
              },
              child: const Text(
                'Choose a photo from gallery',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        );
      },
    );
  }
}
