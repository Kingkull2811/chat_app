import 'package:flutter/material.dart';

import '../../../widgets/custom_app_bar_chat.dart';
import '../chat.dart';

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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBarChat(
        title: widget.item.name,
        image: widget.item.imageUrlAvt,
        onTapLeadingIcon: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: _bodyChat(),
          ),
          _bottomChatField(),
        ],
      ),
    );
  }

  Widget _bodyChat() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: 150,
              width: 150,
              child: CircleAvatar(
                radius: 75,
                child: Image.asset(widget.item.imageUrlAvt ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                widget.item.name ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 50),
              child: Text(
                'Say hi to start chat, ${widget.item.name}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    _buildMessageItem(itemMessage[index]),
                itemCount: itemMessage.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(MessageListItem message) {
    final isMe = message.sender == 'You';

    switch (message.typeMessage) {
      case TypeMessage.text:
        return ListTile(
          title: Text(message.message),
          subtitle: Text(message.timestamp),
          trailing: isMe ? null : Icon(Icons.person),
        );
      case TypeMessage.image:
        return ListTile(
          title: Image.asset(message.message),
          subtitle: Text(message.timestamp),
          trailing: isMe ? null : Icon(Icons.person),
        );
      case TypeMessage.video:
        // Implement video message
        return Container();
      case TypeMessage.audio:
        // Implement audio message
        return Container();
      default:
        // Default message
        return ListTile(
          title: Text('Unsupported message type'),
        );
    }
  }

  Widget _bottomChatField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 66,
        padding: const EdgeInsets.only(bottom: 0, left: 16, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.grid_view_outlined,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.image_outlined,
                size: 24,
                color: Theme.of(context).primaryColor,
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
                onPressed: () {},
                icon: Icon(
                  _showIconSend ? Icons.send_outlined : Icons.mic_none_outlined,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        ),
      ),
    );
  }
}

enum TypeMessage { text, image, video, audio }

enum MessageStatus { notSent, notView, viewed }

List<MessageListItem> itemMessage = [
  MessageListItem(
    sender: 'Martha',
    receiver: 'You',
    message: 'Hello',
    typeMessage: TypeMessage.text,
    timestamp: '2023-3-09T10:00:00.000Z',
  ),
  MessageListItem(
    sender: 'Martha',
    receiver: 'You',
    message: 'assets/images/image_onboarding_1.png',
    typeMessage: TypeMessage.image,
    timestamp: '2023-3-09T10:05:00.000Z',
  ),
  MessageListItem(
    sender: 'You',
    receiver: 'Martha',
    message: 'Hello',
    typeMessage: TypeMessage.text,
    timestamp: '2023-3-09T10:00:00.000Z',
  ),
  MessageListItem(
    sender: 'You',
    receiver: 'Martha',
    message: 'Hello',
    typeMessage: TypeMessage.video,
    timestamp: '2023-3-09T10:00:00.000Z',
  ),
];

class MessageListItem {
  final String sender;
  final String receiver;
  final dynamic message;
  final TypeMessage typeMessage;
  final String timestamp;

  MessageListItem(
      {required this.sender,
      required this.receiver,
      required this.message,
      required this.typeMessage,
      required this.timestamp});
}
