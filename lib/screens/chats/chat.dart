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
  return GestureDetector(
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
                      item.imageUrl ?? '',
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          (item.subtitle ?? '') + (item.time ?? ''),
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
            width: 20,
            child: Image.asset(
              'assets/images/ic_v_green.png',
              width: 20,
              height: 20,
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
    title: 'Item 1',
    subtitle: 'Subtitle 1',
    time: '12:00 PM',
    imageUrl: 'assets/images/image_profile_1.png',
    isRead: false,
  ),
  CustomListItem(
    title: 'Item 2',
    subtitle: 'Subtitle 2',
    time: '1:00 PM',
    imageUrl: 'assets/images/image_profile_2.png',
    isRead: true,
  ),
  CustomListItem(
    title: 'Item 3',
    subtitle: 'Subtitle 3',
    time: '2:00 PM',
    imageUrl: 'assets/images/image_profile_3.png',
    isRead: false,
  ),
  CustomListItem(
    title: 'Item 4',
    subtitle: 'Subtitle 3',
    time: '2:00 PM',
    imageUrl: 'assets/images/image_profile_4.png',
    isRead: true,
  ),
  CustomListItem(
    title: 'Item 5',
    subtitle: 'Subtitle 3',
    time: '2:00 PM',
    imageUrl: 'assets/images/image_profile_5.png',
    isRead: false,
  ),
  CustomListItem(
    title: 'Item 6',
    subtitle: 'Subtitle 3',
    time: '2:00 PM',
    imageUrl: 'assets/images/image_profile_6.png',
    isRead: true,
  ),
  CustomListItem(
    title: 'Item 7',
    subtitle: 'Subtitle 1',
    time: '12:00 PM',
    imageUrl: 'assets/images/image_profile_1.png',
    isRead: false,
  ),
  CustomListItem(
    title: 'Item 8',
    subtitle: 'Subtitle 2',
    time: '1:00 PM',
    imageUrl: 'assets/images/image_profile_2.png',
    isRead: true,
  ),
  CustomListItem(
    title: 'Item 9',
    subtitle: 'Subtitle 3',
    time: '2:00 PM',
    imageUrl: 'assets/images/image_profile_3.png',
    isRead: false,
  ),
  CustomListItem(
    title: 'Item 10',
    subtitle: 'Subtitle 3',
    time: '2:00 PM',
    imageUrl: 'assets/images/image_profile_4.png',
    isRead: true,
  ),
  CustomListItem(
    title: 'Item 11',
    subtitle: 'Subtitle 3',
    time: '2:00 PM',
    imageUrl: 'assets/images/image_profile_5.png',
    isRead: false,
  ),
  CustomListItem(
    title: 'Item 12',
    subtitle: 'Subtitle 3',
    time: '2:00 PM',
    imageUrl: 'assets/images/image_profile_6.png',
    isRead: true,
  ),
];

class CustomListItem {
  final String? title;
  final String? subtitle;
  final String? time;
  final String? imageUrl;
  final bool isRead;

  CustomListItem(
      {this.title,
      this.subtitle,
      this.time,
      this.imageUrl,
      this.isRead = false});
}
