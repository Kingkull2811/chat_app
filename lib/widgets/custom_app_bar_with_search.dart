import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onIconPressed;
  final Function()? onTap;
  final Function()? onTapTextField;

  CustomAppBar({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onIconPressed,
    this.onTap,
    this.onTapTextField,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(title,style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black,),),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 16),
          child: Container(
            height: 40, width: 40,
            //color: Colors.grey,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
            ),
            child: IconButton(
              icon: Image.asset('assets/images/ic_new_message.png'),
              onPressed: onIconPressed,
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
