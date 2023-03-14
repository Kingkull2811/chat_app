import 'package:chat_app/screens/chats/chat.dart';
import 'package:chat_app/screens/chats/on_chatting/on_chatting_bloc.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/custom_app_bar_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'on_chatting_state.dart';

class OnChattingPage extends StatefulWidget {
  final CustomListItem item;

  const OnChattingPage({Key? key, required this.item}) : super(key: key);

  @override
  State<OnChattingPage> createState() => OnChattingPageState();
}

class OnChattingPageState extends State<OnChattingPage> {
  final _inputTextController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showIconSend = false;

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnChattingBloc, OnChattingState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: CustomAppBarChat(
              onTapLeadingIcon: () {
                Navigator.pop(context);
              },
            ),
            body: const AnimationLoading(),
          );
        }
        return Scaffold(
          appBar: CustomAppBarChat(
            title: widget.item.name,
            image: widget.item.imageUrlAvt,
            onTapLeadingIcon: () {
              Navigator.pop(context);
            },
          ),
          resizeToAvoidBottomInset: true,
          body: Column(
            children: <Widget>[
              _bodyChat(),
              _bottomChatField(),
            ],
          ),
        );
      },
    );
  }

  Widget _bodyChat() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                padding:const EdgeInsets.only(top: 40, bottom: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        radius: 75,
                        child: Image.asset(widget.item.imageUrlAvt ?? '',fit: BoxFit.cover,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        widget.item.name ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Say hi to start chat, ${widget.item.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return _chatItem(
              context,
              itemMessage[index - 1],
            );
          },
          itemCount: itemMessage.length + 1,
        ),
      ),
    );
  }

  Widget _bottomChatField() {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              iconSize: 30,
              icon: Icon(
                Icons.grid_view_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              child: IconButton(
                onPressed: () {},
                iconSize: 30,
                icon: Icon(
                  Icons.image_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 35,
                child: TextFormField(
                  controller: _inputTextController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    height: 1.3,
                  ),
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
                      },
                      child: Icon(
                        Icons.emoji_emotions_outlined,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    suffixIconColor: Theme.of(context).primaryColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color.fromARGB(128, 130, 130, 130),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 30,
              onPressed: () {},
              icon: Icon(
                _showIconSend ? Icons.send_outlined : Icons.mic_none_outlined,
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
    MessageItem itemMessage,
  ) {
    final isMe = itemMessage.sender == 'You';
    Widget messageContain(MessageItem itemMessage) {
      switch (itemMessage.typeMessage) {
        case TypeMessage.text:
          return textMessage(itemMessage, isMe);

        case TypeMessage.image:
          return imageMessage(itemMessage, isMe);

        case TypeMessage.video:
          return videoMessage(itemMessage, isMe);

        case TypeMessage.audio:
          return audioMessage(itemMessage, isMe);

        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: Text(
                '---${itemMessage.timestamp.replaceAll('T', ' ').replaceAll('.000Z', '')}---',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: (itemMessage.sender == 'You')
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isMe) ...[
                Container(
                  height: 24,
                  width: 24,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CircleAvatar(
                    radius: 12,
                    child: Image.asset(widget.item.imageUrlAvt ?? ''),
                  ),
                )
              ],
              Padding(
                padding: EdgeInsets.only(left: isMe ? 0.0 : 10.0),
                child: messageContain(itemMessage),
              ),
              if (isMe) ...[
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    (itemMessage.status == MessageStatus.notSent)
                        ? null
                        : (itemMessage.status == MessageStatus.viewed)
                            ? Icons.done_all
                            : Icons.done,
                    size: 8,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget textMessage(MessageItem itemMessage, bool isMe) {
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
        itemMessage.message,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget imageMessage(MessageItem itemMessage, bool isMe) {
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
              child: ClipRect(
                child: Image.asset(itemMessage.message),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget videoMessage(MessageItem itemMessage, bool isMe) {
    // return Container(
    //   width: MediaQuery.of(context).size.width * 0.65,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     image: const DecorationImage(
    //       image: AssetImage('assets/images/image_onboarding_1.png'),
    //     ),
    //   ),
    //   child: Container(
    //     height: 30,
    //     width: 30,
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).primaryColor,
    //       shape: BoxShape.circle,
    //     ),
    //     child: const Icon(
    //       Icons.play_arrow,
    //       size: 24,
    //       color: Colors.white,
    //     ),
    //   ),
    // );

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
              child: ClipRect(
                child: Image.asset(itemMessage.message),
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

  Widget audioMessage(MessageItem itemMessage, bool isMe) {
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
        width: MediaQuery.of(context).size.width*0.5,
        child: Row(
          children: [
            Icon(
              Icons.play_arrow,
              color:  Theme.of(context).primaryColor,
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

enum TypeMessage { text, image, video, audio }

enum MessageStatus { notSent, notView, viewed }

List<MessageItem> itemMessage = [
  MessageItem(
    sender: 'Martha',
    receiver: 'You',
    message: 'Hello',
    typeMessage: TypeMessage.text,
    timestamp: '2023-03-09T10:00:00.000Z',
    status: MessageStatus.notSent,
  ),
  MessageItem(
    sender: 'Martha',
    receiver: 'You',
    message: 'assets/images/image_onboarding_1.png',
    typeMessage: TypeMessage.image,
    timestamp: '2023-03-09T10:05:00.000Z',
    status: MessageStatus.notSent,
  ),
  MessageItem(
    sender: 'Martha',
    receiver: 'You',
    message: 'assets/images/image_onboarding_1.png',
    typeMessage: TypeMessage.video,
    timestamp: '2023-03-09T10:00:00.000Z',
    status: MessageStatus.notSent,
  ),
  MessageItem(
    sender: 'Martha',
    receiver: 'You',
    message: 'sdadasdaddsdasda',
    typeMessage: TypeMessage.audio,
    timestamp: '2023-03-09T10:01:00.000Z',
    status: MessageStatus.notSent,
  ),
  MessageItem(
    sender: 'You',
    receiver: 'Martha',
    message: 'Hello MMMMM',
    typeMessage: TypeMessage.text,
    timestamp: '2023-03-09T10:12:00.000Z',
    status: MessageStatus.notSent,
  ),
  MessageItem(
    sender: 'You',
    receiver: 'Martha',
    message: 'assets/images/image_onboarding_2.png',
    typeMessage: TypeMessage.image,
    timestamp: '2023-03-09T10:15:00.000Z',
    status: MessageStatus.notView,
  ),
  MessageItem(
    sender: 'You',
    receiver: 'Martha',
    message: 'assets/images/image_onboarding_2.png',
    typeMessage: TypeMessage.video,
    timestamp: '2023-03-09T10:00:00.000Z',
    status: MessageStatus.viewed,
  ),
  MessageItem(
    sender: 'You',
    receiver: 'Martha',
    message: 'Hello cccc',
    typeMessage: TypeMessage.audio,
    timestamp: '2023-03-09T10:18:00.000Z',
    status: MessageStatus.viewed,
  ),
  MessageItem(
    sender: 'Martha',
    receiver: 'You',
    message: 'Helloooooo',
    typeMessage: TypeMessage.text,
    timestamp: '2023-03-09T10:20:00.000Z',
    status: MessageStatus.notSent,
  ),
  MessageItem(
    sender: 'Martha',
    receiver: 'You',
    message: 'assets/images/image_onboarding_3.png',
    typeMessage: TypeMessage.image,
    timestamp: '2023-03-09T10:25:00.000Z',
    status: MessageStatus.notSent,
  ),
];

class MessageItem {
  final String sender;
  final String receiver;
  final dynamic message;
  final MessageStatus status;
  final TypeMessage typeMessage;
  final String timestamp;

  MessageItem(
      {required this.sender,
      required this.receiver,
      required this.message,
      required this.status,
      required this.typeMessage,
      required this.timestamp});
}
