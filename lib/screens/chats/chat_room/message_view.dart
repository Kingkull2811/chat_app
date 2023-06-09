import 'dart:io';

import 'package:chat_app/network/model/message_model.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/utilities/enum/message_type.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/notification_controller.dart';
import '../../../services/permission.dart';
import '../../../theme.dart';
import '../../../utilities/call_utils.dart';
import '../../../utilities/enum/call_type.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/app_image.dart';
import '../call/call_incoming/call_incoming.dart';
import '../chat_info/chat_info.dart';

class MessageView extends StatefulWidget {
  final String receiverId, receiverName, receiverAvt, receiverFCMToken;

  const MessageView({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvt,
    required this.receiverFCMToken,
  }) : super(key: key);

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final _firebaseService = FirebaseService();

  final _inputTextController = TextEditingController();

  var docID;

  final _pref = SharedPreferencesStorage();

  final int currentUserId = SharedPreferencesStorage().getUserId();

  bool showEmoji = false;

  void _checkMessage() async {
    var newDocID = await _firebaseService.checkMessageExists(
      currentUserId: currentUserId,
      receiverId: widget.receiverId,
      receiverAvt: widget.receiverAvt,
      receiverName: widget.receiverName,
      receiverFCMToken: widget.receiverFCMToken,
    );

    await _firebaseService.sendCurrentDeviceFCMToken(docID: newDocID);

    setState(() {
      docID = newDocID;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkMessage();
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (showEmoji) {
            setState(() => showEmoji = !showEmoji);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: CallIncomingPage(
          scaffold: Scaffold(
            appBar: _appBar(),
            resizeToAvoidBottomInset: true,
            body: Column(
              children: <Widget>[
                Expanded(
                  child: _bodyChat(),
                ),
                _chatInput(),
                _emojiPick(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyChat() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getMessage(docID),
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
          List<MessageModel> listMessage = [];

          final data = snapshot.data?.docs;

          for (var doc in data!) {
            if (doc.exists) {
              if (doc.data() is Map<String, dynamic>) {
                final message = MessageModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                );
                listMessage.add(message);
              }
            }
          }
          return _listMessage(listMessage);
        } else {
          return _helloMessage();
        }
      },
    );
  }

  Widget _listMessage(List<MessageModel>? listMessage) {
    if (isNullOrEmpty(listMessage)) {
      return _helloMessage();
    } else {
      return ListView.builder(
        reverse: true,
        scrollDirection: Axis.vertical,
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
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: AppImage(
                isOnline: true,
                localPathOrUrl: widget.receiverAvt,
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
              widget.receiverName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Say hi 👋 to start chat with ${widget.receiverName}',
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
              onPressed: () => _pickImageToSend(context),
              iconSize: 30,
              icon: const Icon(
                Icons.image_outlined,
                color: AppColors.primaryColor,
              ),
            ),
            // GestureDetector(
            //   onTap: () {},
            //   onLongPress: () async {},
            //   onLongPressEnd: (_) {},
            //   child: const Icon(
            //     Icons.mic_none_outlined,
            //     size: 30,
            //     color: AppColors.primaryColor,
            //   ),
            // ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                child: TextFormField(
                  onTap: () {
                    if (showEmoji) {
                      setState(() => showEmoji = !showEmoji);
                    }
                  },
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
                      onTap: () => setState(() => showEmoji = !showEmoji),
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
                if (_inputTextController.text.isEmpty) {
                  return;
                } else {
                  await _firebaseService.sendTextMessage(
                    docID: docID,
                    messageText: _inputTextController.text.trim(),
                    currentUserId: currentUserId,
                    receiverFCMToken: widget.receiverFCMToken,
                  );
                  _inputTextController.clear();
                }
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

  Widget _emojiPick() {
    return Offstage(
      offstage: !showEmoji,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
          textEditingController: _inputTextController,
          config: Config(
            columns: 7,
            emojiSizeMax: 32 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS ||
                        Platform.isIOS
                    ? 1.30
                    : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            initCategory: Category.RECENT,
            bgColor: AppColors.primaryColor.withOpacity(0.1),
            indicatorColor: AppColors.primaryColor,
            iconColor: Colors.grey.withOpacity(0.3),
            iconColorSelected: AppColors.primaryColor,
            backspaceColor: AppColors.primaryColor,
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.grey,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            replaceEmojiOnLimitExceed: false,
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
            checkPlatformCompatibility: true,
          ),
        ),
      ),
    );
  }

  Widget _chatItem(
    BuildContext context,
    MessageModel message,
  ) {
    final isMe = message.fromId == _pref.getUserId();
    Widget messageContain(MessageModel itemMessage) {
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
            convertTimestampToDateTime(message.time),
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

  Widget textMessage(MessageModel message, bool isMe) {
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

  Widget imageMessage(MessageModel itemMessage, bool isMe) {
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

  Widget videoMessage(MessageModel itemMessage, bool isMe) {
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

  Widget audioMessage(MessageModel itemMessage, bool isMe) {
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
                if (isNullOrEmpty(imagePath)) {
                  return;
                } else {
                  await _firebaseService.sendImageMessage(
                    docID,
                    imagePath,
                    widget.receiverFCMToken,
                  );
                }
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
                if (isNullOrEmpty(imagePath)) {
                  return;
                } else {
                  await _firebaseService.sendImageMessage(
                    docID,
                    imagePath,
                    widget.receiverFCMToken,
                  );
                }
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

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0.5,
      backgroundColor: AppColors.primaryColor,
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
                localPathOrUrl: widget.receiverAvt,
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
              widget.receiverName,
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
          icon: const Icon(Icons.phone, size: 24, color: Colors.white),
          onPressed: () async =>
              await PermissionsServices.microphonePermissionsGranted()
                  ? CallUtils.dialVoice(
                      context: context,
                      isFromChat: true,
                      callerId: _pref.getUserId().toString(),
                      callerName: _pref.getFullName(),
                      callerPic: _pref.getImageAvartarUrl(),
                      callerFCMToken:
                          await NotificationController.requestFirebaseToken(),
                      receiverId: widget.receiverId,
                      receiverName: widget.receiverName,
                      receiverPic: widget.receiverAvt,
                      receiverFCMToken: widget.receiverFCMToken,
                      callType: CallType.call_audio,
                    )
                  : {},
        ),
        IconButton(
          icon: const Icon(
            CupertinoIcons.video_camera_solid,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () async =>
              await PermissionsServices.cameraAndMicrophonePermissionsGranted()
                  ? CallUtils.dialVideo(
                      context: context,
                      isFromChat: true,
                      callerId: _pref.getUserId().toString(),
                      callerName: _pref.getFullName(),
                      callerPic: _pref.getImageAvartarUrl(),
                      callerFCMToken:
                          await NotificationController.requestFirebaseToken(),
                      receiverId: widget.receiverId,
                      receiverName: widget.receiverName,
                      receiverPic: widget.receiverAvt,
                      receiverFCMToken: widget.receiverFCMToken,
                      callType: CallType.call_video,
                    )
                  : {},
        ),
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
                  name: widget.receiverName,
                  imageUrl: widget.receiverAvt,
                  receiverID: widget.receiverId,
                  docID: docID,
                ),
              ),
            );
            // Add the action you want to perform when the icon is tapped
          },
        ),
      ],
    );
  }
}
