import 'package:flutter/material.dart';

class CustomAppBarChat extends StatelessWidget implements PreferredSizeWidget {
  final String? image;
  final String? title;
  final Function()? onTapLeadingIcon;

  const CustomAppBarChat({super.key, this.image, this.title, this.onTapLeadingIcon});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      leadingWidth: 30,
      leading: IconButton(
        icon:  Icon(Icons.arrow_back_ios_new, size: 24,color: Theme.of(context).primaryColor,),
        onPressed: onTapLeadingIcon,
      ),
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: CircleAvatar(radius: 30,
            child: Image.asset(image??''),),
          ),
          const SizedBox(width: 8),
          Text(title??'', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call_outlined, size: 20, color: Theme.of(context).primaryColor,),
          onPressed: () {
            // Add the action you want to perform when the icon is tapped
          },
        ),
        IconButton(
          icon: Icon(Icons.videocam_outlined, size: 24,color: Theme.of(context).primaryColor,),
          onPressed: () {
            // Add the action you want to perform when the icon is tapped
          },
        ),
        IconButton(
          icon: Icon(Icons.info_outline, size: 20,color: Theme.of(context).primaryColor,),
          onPressed: () {
            // Add the action you want to perform when the icon is tapped
          },
        ),
      ],
    );
  }
}