import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase_services.dart';
import '../../../widgets/animation_loading.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _searchController = TextEditingController();

  bool _showSearchResult = false;

  bool isRead = false;

  @override
  void initState() {
    _searchController.addListener(() {
      _showSearchResult = _searchController.text.isNotEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService().getListChatByUserID(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const AnimationLoading();
          case ConnectionState.active:
          case ConnectionState.done:
            return Container();
        }
      },
    );

    // return ListView.builder(
    //   scrollDirection: Axis.vertical,
    //   physics: const BouncingScrollPhysics(),
    //   itemCount: 10,
    //   itemBuilder: (context, index) => _itemChat(),
    // );
  }

  Widget _itemChat() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        child: ListTile(
          onTap: () {},
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: AppImage(
                isOnline: true,
                localPathOrUrl: '',
                boxFit: BoxFit.cover,
                errorWidget: Container(
                  color: Colors.grey.withOpacity(0.2),
                  child: const Icon(
                    Icons.person_outline,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'item.time',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'item.lastMessage',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    isRead ? Icons.check_circle : Icons.check_circle_outline,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<CustomListItem> itemList = [
  CustomListItem(
    name: 'Item 1',
    lastMessage: 'Subtitle 1',
    time: '12:00 PM',
    imageUrlAvt: 'assets/images/image_profile_1.png',
    isRead: false,
  ),
  CustomListItem(
    name: 'Item 2',
    lastMessage: 'Subtitle 2 1as asd ef ca cas c s',
    time: '1:00 PM',
    imageUrlAvt: 'assets/images/image_profile_2.png',
    isRead: true,
  ),
  CustomListItem(
    name: 'Item 3',
    lastMessage: 'Subtitle 3',
    time: '2:00 PM',
    imageUrlAvt: 'assets/images/image_profile_3.png',
    isRead: false,
  ),
  CustomListItem(
    name: 'Item 4',
    lastMessage: 'Subtitle 3',
    time: '2:00 PM',
    imageUrlAvt: 'assets/images/image_profile_4.png',
    isRead: true,
  ),
  CustomListItem(
    name: 'Item 5',
    lastMessage: 'Subtitle 3',
    time: '2:00 PM',
    imageUrlAvt: 'assets/images/image_profile_5.png',
    isRead: false,
  ),
  CustomListItem(
    name: 'Item 6',
    lastMessage: 'Subtitle 3',
    time: '2:00 PM',
    imageUrlAvt: 'assets/images/image_profile_6.png',
    isRead: true,
  ),
  CustomListItem(
    name: 'Item 7',
    lastMessage: 'Subtitle 1',
    time: '12:00 PM',
    imageUrlAvt: 'assets/images/image_profile_1.png',
    isRead: false,
  ),
  CustomListItem(
    name: 'Item 8',
    lastMessage: 'Subtitle 2',
    time: '1:00 PM',
    imageUrlAvt: 'assets/images/image_profile_2.png',
    isRead: true,
  ),
  CustomListItem(
    name: 'Item 9',
    lastMessage: 'Subtitle 3',
    time: '2:00 PM',
    imageUrlAvt: 'assets/images/image_profile_3.png',
    isRead: false,
  ),
  CustomListItem(
    name: 'Item 10',
    lastMessage: 'Subtitle 3',
    time: '2:00 PM',
    imageUrlAvt: 'assets/images/image_profile_4.png',
    isRead: true,
  ),
  CustomListItem(
    name: 'Item 11',
    lastMessage: 'Subtitle 3',
    time: '2:00 PM',
    imageUrlAvt: 'assets/images/image_profile_5.png',
    isRead: false,
  ),
  CustomListItem(
    name: 'Item 12',
    lastMessage: 'Subtitle 3',
    time: '2:00 PM',
    imageUrlAvt: 'assets/images/image_profile_6.png',
    isRead: true,
  ),
];

class CustomListItem {
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrlAvt;
  final bool isRead;
  final bool isActive;

  CustomListItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrlAvt,
    this.isRead = false,
    this.isActive = false,
  });
}
