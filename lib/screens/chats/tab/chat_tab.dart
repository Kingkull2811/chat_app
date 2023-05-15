import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat_room/chat_room.dart';
import '../chat_room/chat_room_bloc.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _searchController = TextEditingController();

  bool _showSearchResult = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchBox(context),
        Expanded(
          child: _showSearchResult
              ? _searchResult()
              : SizedBox(
                  height: 71 * (itemList.length).toDouble(),
                  child: ListView.separated(
                    reverse: false,
                    separatorBuilder: (context, index) {
                      if (index == 0) {
                        return const Divider(
                          height: 1,
                          color: Colors.transparent,
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16.0),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey[200],
                        ),
                      );
                    },
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      return _cardChat(context, itemList[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _searchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
      child: SizedBox(
        height: 40,
        child: TextField(
          onTap: () {
            setState(() {
              _showSearchResult = !_showSearchResult;
            });
          },
          controller: _searchController,
          onSubmitted: (_) {
            if (_searchController.text.isEmpty) {
              setState(() {
                _showSearchResult = false;
              });
            }
          },
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
                width: 1,
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
    );
  }

  Widget _searchResult() {
    return Container(color: Colors.blue);
  }

  Widget _cardChat(
    BuildContext context,
    CustomListItem item,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<OnChattingBloc>(
                create: (context) => OnChattingBloc(context),
                child: ChatRoom(item: item),
              ),
            ),
          );
        },
        child: SizedBox(
          height: 70,
          child: ListTile(
            leading: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                child: Image.asset(
                  item.imageUrlAvt,
                ),
              ),
            ),
            title: Text(
              item.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.45,
                    ),
                    child: Text(
                      item.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
            trailing: SizedBox(
              width: 16,
              child: Icon(
                item.isRead ? Icons.check_circle : Icons.check_circle_outline,
                size: 16,
                color: Colors.grey,
              ),
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
