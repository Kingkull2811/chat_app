import 'package:chat_app/screens/chats/on_chatting/on_chatting.dart';
import 'package:chat_app/screens/chats/on_chatting/on_chatting_bloc.dart';
import 'package:chat_app/widgets/custom_app_bar_with_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chat',
        imageUrl: 'assets/images/image_profile_1.png',
        onTap: () {},
        onTapTextField: () {},
        onIconPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
        child: ListView.separated(
          itemBuilder: (context, index) =>
              _cardChat(itemList[index], width, context),
          separatorBuilder: (context, index) => Divider(),
          itemCount: itemList.length,
        ),
      ),
    );
  }

  void reloadPage() {
    //BlocProvider.of<ChatsPageBloc>(context).add();
  }
}

_cardChat(CustomListItem item, double width, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider<OnChattingBloc>(
                    create: (context) => OnChattingBloc(context),
                    child: OnChattingPage(item: item),
                  )));
    },
    child: SizedBox(
      height: 70,
      width: width - 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width - 52,
            child: Row(
              children: [
                Container(
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
                      item.imageUrlAvt ?? '',
                    ),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${item.name} ${item.time}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                        )
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            width: 16,
            child: Image.asset(
              'assets/images/ic_v_green.png',
              width: 16,
              height: 16,
              color: Colors.grey,
            ),
          )
        ],
      ),
    ),
  );
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
    lastMessage: 'Subtitle 2',
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
  final String? name;
  final String? lastMessage;
  final String? time;
  final String? imageUrlAvt;
  final bool isRead;
  final bool isActive;

  CustomListItem({
    this.name,
    this.lastMessage,
    this.time,
    this.imageUrlAvt,
    this.isRead = false,
    this.isActive = false,
  });
}
