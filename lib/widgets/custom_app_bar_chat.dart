import 'package:chat_app/screens/chats/chat_info/chat_info.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBarChat extends StatelessWidget implements PreferredSizeWidget {
  final String image;
  final String title;
  final Function()? onTapLeadingIcon;

  const CustomAppBarChat({
    super.key,
    required this.image,
    required this.title,
    this.onTapLeadingIcon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Theme.of(context).primaryColor,
      leadingWidth: 30,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 24,
          color: Colors.white,
        ),
        onPressed: onTapLeadingIcon,
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
                localPathOrUrl: image,
                boxFit: BoxFit.cover,
                errorWidget: Icon(
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
              title,
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
        // IconButton(
        //   icon: Icon(
        //     Icons.call_outlined,
        //     size: 20,
        //     color: Theme.of(context).primaryColor,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => AudioCallPage(
        //           imageUrl: image,
        //           name: title,
        //         ),
        //       ),
        //     );
        //
        //     // Add the action you want to perform when the icon is tapped
        //   },
        // ),
        // IconButton(
        //   icon: Icon(
        //     Icons.videocam_outlined,
        //     size: 24,
        //     color: Theme.of(context).primaryColor,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => VideoCallPage(
        //           imageUrl: image,
        //           name: title,
        //         ),
        //       ),
        //     );
        //     // Add the action you want to perform when the icon is tapped
        //   },
        // ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatInfoPage(
                  name: title,
                  urlImage: image,
                  isGroup: true,
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
