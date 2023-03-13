import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final String imageUrl;
  final Function()? onTapIconNewMessage;
  final Function()? onTapAppBar;
  final Function()? onTapTextField;

  CustomAppBar({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTapIconNewMessage,
    this.onTapAppBar,
    this.onTapTextField,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Builder(
        builder: (context){
          return GestureDetector(
            onTap: onTapAppBar,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.only(left: 0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(imageUrl),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0,),
          child: GestureDetector(
            onTap: onTapIconNewMessage,
            child: ImageIcon(
                const AssetImage('assets/images/ic_new_message.png'),
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Container(
            height: 60,
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: onTapTextField,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60.0);
}
