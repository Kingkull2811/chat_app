import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final String imageUrl;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final Function()? onTapIconNewMessage;
  final Function()? onTapAppBar;
  final Function()? onTapTextField;

  CustomAppBar({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.searchController,
    required this.focusNode,
    this.onTapIconNewMessage,
    this.onTapAppBar,
    this.onTapTextField,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      // automaticallyImplyLeading: false,
      leading: Container(
        height: 40,
        width: 40,
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
          ),
          child: GestureDetector(
            onTap: onTapIconNewMessage,
            child: Icon(
              Icons.add_comment_outlined,
              size: 28,
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
                controller: searchController,
                focusNode: focusNode,
                onSubmitted: (_) => focusNode.requestFocus(),
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color.fromARGB(128, 130, 130, 130),
                    ),
                  ),
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
