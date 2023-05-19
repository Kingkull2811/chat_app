import 'package:chat_app/routes.dart';
import 'package:chat_app/screens/chats/call/audio_call/audio_call.dart';
import 'package:chat_app/screens/chats/call/video_call/video_call.dart';
import 'package:chat_app/screens/chats/group_participants/group_participants.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utilities/screen_utilities.dart';
import '../../../widgets/app_image.dart';

class ChatInfoPage extends StatelessWidget {
  final bool isGroup;
  final int receiverID;
  final String name;
  final String? imageUrl;

  const ChatInfoPage({
    Key? key,
    this.isGroup = false,
    required this.receiverID,
    required this.name,
    this.imageUrl,
  }) : super(key: key);

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
                    localPathOrUrl: imageUrl,
                    boxFit: BoxFit.cover,
                    errorWidget: const Icon(
                      CupertinoIcons.person,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
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
                          builder: (context) => AudioCallPage(
                            imageUrl: imageUrl ?? '',
                            name: name,
                          ),
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
                          builder: (context) => VideoCallPage(
                            imageUrl: imageUrl ?? '',
                            name: name,
                          ),
                        ),
                      );
                    },
                  ),
                  if (!isGroup)
                    _itemControl(
                      context,
                      icon: Icons.person_outline,
                      itemTitle: 'Profile',
                      onTapItemControl: () {},
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    if (isGroup)
                      _itemInfo(
                        itemTitle: 'Group participants',
                        icon: Icons.groups,
                        onTapItem: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GroupParticipantPage(),
                            ),
                          );
                        },
                      ),
                    if (!isGroup)
                      _itemInfo(
                        itemTitle: 'Block',
                        icon: Icons.speaker_notes_off_outlined,
                        onTapItem: () async {
                          showMessageTwoOption(
                            context,
                            'Block $name?',
                            content:
                                'Do you want block $name.\nAfter block, you can send message to $name and vice versa.',
                            okLabel: 'Block',
                            onOk: () {
                              //todo:::
                              //bloc user and back to chat
                              Navigator.of(context).pop(true);
                            },
                          );
                        },
                      ),
                    _itemInfo(
                      itemTitle: 'Delete chat',
                      icon: CupertinoIcons.delete,
                      isRed: true,
                      onTapItem: () async {
                        showMessageTwoOption(
                          context,
                          'Delete chat',
                          content:
                              'Do you want delete this chat.\nAfter delete, you can\'t restore this chat.',
                          okLabel: 'Delete',
                          onOk: () {
                            //todo:::
                            //delete this chat and go to main app
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.chat,
                              (route) => false,
                            );
                          },
                        );
                      },
                    ),
                    if (isGroup)
                      _itemInfo(
                        itemTitle: 'Leave group',
                        icon: Icons.output_outlined,
                        isRed: true,
                        onTapItem: () async {
                          showMessageTwoOption(
                            context,
                            'Leave group chat',
                            content: 'Do you want leave group chat?',
                            okLabel: 'Leave',
                            onOk: () {
                              //todo:::
                              //leave user out group chat
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.chat,
                                (route) => false,
                              );
                            },
                          );
                        },
                      ),
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
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                size: 30,
                color: AppColors.primaryColor,
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
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: isRed ? AppColors.red700 : Colors.black,
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isRed ? AppColors.red700 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
