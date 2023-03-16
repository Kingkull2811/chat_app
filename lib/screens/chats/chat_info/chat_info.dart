import 'package:chat_app/screens/chats/audio_call/audio_call.dart';
import 'package:chat_app/screens/chats/group_participants/group_participants.dart';
import 'package:chat_app/screens/chats/media_shared/media_shared.dart';
import 'package:chat_app/screens/chats/video_call/video_call.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/widgets/message_dialog_2_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInfoPage extends StatefulWidget {
  final bool isGroup;
  final String name;
  final String urlImage;

  const ChatInfoPage({
    Key? key,
    this.isGroup = false,
    required this.name,
    required this.urlImage,
  }) : super(key: key);

  @override
  State<ChatInfoPage> createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  bool _isMute = false;
  final _focusNode = FocusNode();
  final _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(widget.urlImage),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _itemControl(
                    context,
                    icon: Icons.call_outlined,
                    itemTitle: 'Audio',
                    onTapItemControl: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AudioCallPage(),
                        ),
                      );
                    },
                  ),
                  _itemControl(
                    context,
                    icon: Icons.videocam_outlined,
                    itemTitle: 'Video',
                    onTapItemControl: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VideoCallPage(),
                        ),
                      );
                    },
                  ),
                  _itemControl(context,
                      icon: widget.isGroup
                          ? Icons.person_add_alt_outlined
                          : Icons.person_outline,
                      itemTitle: widget.isGroup ? 'Add' : 'Profile',
                      onTapItemControl: () {}),
                  _itemControl(
                    context,
                    icon: _isMute
                        ? Icons.notifications_on_outlined
                        : Icons.notifications_off_outlined,
                    itemTitle: _isMute ? 'UnMute' : 'Mute',
                    isActive: !_isMute,
                    onTapItemControl: () {
                      setState(() {
                        _isMute = !_isMute;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    widget.isGroup
                        ? _itemInfo(
                            itemTitle: 'Group participants',
                            icon: Icons.groups,
                            onTapItem: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupParticipantPage(),
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                    _itemInfo(
                      itemTitle: 'Search in conversation',
                      icon: Icons.search_rounded,
                      onTapItem: () async {
                        await showDialog(
                          barrierColor: Colors.grey[500],
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            //todo:::
                            //set align top when keyboard show, center when keyboard hide
                            alignment: Alignment.topCenter,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Search in conversation',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    size: 24,
                                    color: AppConstants().red700,
                                  ),
                                ),
                              ],
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: 300,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: TextField(
                                      controller: _searchController,
                                      onSubmitted: (_) =>
                                          _focusNode.requestFocus(),
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          size: 24,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        prefixIconColor:
                                            Theme.of(context).primaryColor,
                                        hintText: 'Search...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 6.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                                128, 130, 130, 130),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        color: Colors.grey,
                                        child: const Text('Result of search'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _itemInfo(
                      itemTitle: 'Files, medias, documents & links',
                      // icon: CupertinoIcons.doc,
                      icon: CupertinoIcons.photo_on_rectangle,
                      onTapItem: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MediaShared(),
                          ),
                        );
                      },
                    ),

                    // _itemInfo(
                    //   itemTitle: 'Ignore message',
                    //   icon: Icons.hide_source_outlined,
                    //   onTapItem: () {},
                    //),
                    widget.isGroup
                        ? const SizedBox.shrink()
                        : _itemInfo(
                            itemTitle: 'Block',
                            icon: Icons.speaker_notes_off_outlined,
                            onTapItem: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => MessageDialog2Action(
                                  title: 'Block ${widget.name}?',
                                  content:
                                      'Do you want block ${widget.name}.\nAfter block, you can send message to ${widget.name} and vice versa.',
                                  buttonLeftLabel: 'Cancel',
                                  onLeftTap: () {
                                    Navigator.pop(context);
                                  },
                                  buttonRightLabel: 'Block',
                                  onRightTap: () {
                                    //todo:::
                                    //back to on chatting and can't send message
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                    _itemInfo(
                      itemTitle: 'Delete chat',
                      icon: CupertinoIcons.delete,
                      isRed: true,
                      onTapItem: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => MessageDialog2Action(
                            title: 'Delete chat',
                            content:
                                'Do you want delete this chat.\nAfter delete, you can\'t restore this chat.',
                            buttonLeftLabel: 'Cancel',
                            onLeftTap: () {
                              Navigator.pop(context);
                            },
                            buttonRightLabel: 'Delete',
                            isRedLabel: true,
                            onRightTap: () {
                              //todo:::
                              //delete this chat and go to main app

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => TabBloc(),
                                    child: MainApp(),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    widget.isGroup
                        ? _itemInfo(
                            itemTitle: 'Leave group',
                            icon: Icons.output_outlined,
                            isRed: true,
                            onTapItem: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => MessageDialog2Action(
                                  title: 'Leave group chat',
                                  content: 'Do you want leave group chat.',
                                  buttonLeftLabel: 'Cancel',
                                  onLeftTap: () {
                                    Navigator.pop(context);
                                  },
                                  buttonRightLabel: 'Leave',
                                  isRedLabel: true,
                                  onRightTap: () {
                                    //todo:::
                                    //leave user out group chat

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => TabBloc(),
                                          child: MainApp(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _itemControl(
    BuildContext context, {
    required IconData? icon,
    bool isActive = false,
    required String itemTitle,
    Function()? onTapItemControl,
  }) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onTapItemControl,
        child: Column(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                itemTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _itemInfo({
    required String itemTitle,
    required IconData icon,
    bool isRed = false,
    Function()? onTapItem,
  }) {
    return InkWell(
      onTap: onTapItem,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              itemTitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isRed ? AppConstants().red700 : Colors.black,
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
              child: Icon(
                icon,
                size: 18,
                color: isRed ? AppConstants().red700 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
