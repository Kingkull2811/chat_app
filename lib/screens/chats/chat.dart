import 'package:chat_app/screens/chats/on_chatting/on_chatting.dart';
import 'package:chat_app/screens/chats/on_chatting/on_chatting_bloc.dart';
import 'package:chat_app/screens/main/menu/drawer_menu.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/custom_app_bar_with_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> {
  final _focusNode = FocusNode();
  final _searchController = TextEditingController();
  final _searchNewMessageController = TextEditingController();

  bool isNightMode = SharedPreferencesStorage().getNightMode() ?? false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chat',
        imageUrl: 'assets/images/image_profile_1.png',
        searchController: _searchController,
        focusNode: _focusNode,
        onTapTextField: () {},
        onTapIconNewMessage: () {
          _createNewMessage(
            context,
            width,
          );
          //todo:::  RangeError (index): Invalid value: Not in inclusive range 0..11: 12
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
        child: ListView.separated(
          reverse: false,
          itemBuilder: (context, index) =>
              _cardChat(itemList[index], width, context),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[100],
          ),
          itemCount: itemList.length,
        ),
      ),
      //drawerEnableOpenDragGesture: false,
      drawer: DrawerMenu(
        imageUrl: 'assets/images/image_profile_1.png',
        name: 'Martha Craig',
        onTapNightMode: (value) {
          setState(() {
            isNightMode = !isNightMode;
            SharedPreferencesStorage().setNightMode(isNightMode);
          });
        },
      ),
    );
  }

  void reloadPage() {
    //BlocProvider.of<ChatsPageBloc>(context).add();
  }

  _createNewMessage(
    BuildContext context,
    double width,
  ) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (value) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.9,
          color: AppConstants().grey630,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.45,
                      top: 6,
                      right: width * 0.45,
                      bottom: 5),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 14),
                          )),
                      const Text(
                        'New Message',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //todo:::
                          if (kDebugMode) {
                            print('go to on chatting');
                          }
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => BlocProvider<OnChattingBloc>(
                          //       create: (context) => OnChattingBloc(context),
                          //       child: OnChattingPage(
                          //         item: CustomListItem(
                          //           name: 'Item 1',
                          //           lastMessage: 'Subtitle 1',
                          //           time: '12:00 PM',
                          //           imageUrlAvt:
                          //               'assets/images/image_profile_1.png',
                          //           isRead: false,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // );
                        },
                        child: Text(
                          'Create',
                          style:
                              TextStyle(fontSize: 14, color: Colors.blue[300]),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      controller: _searchNewMessageController,
                      onSubmitted: (_) => _focusNode.requestFocus(),
                      decoration: InputDecoration(
                        hintText: 'To:',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      //todo::::
                      if (kDebugMode) {
                        print('create new group');
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.groups,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Create a new group',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemList.length + 1,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 100, right: 32),
                      child: Divider(
                        color: Theme.of(context).primaryColor,
                        height: 0.5,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          height: 30,
                          padding: const EdgeInsets.only(left: 16, top: 10),
                          child: Text(
                            'Suggest',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }
                      return Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: CircleAvatar(
                                child: Image.asset(
                                  itemList[index].imageUrlAvt ?? '',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  itemList[index].name ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              'email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cardChat(CustomListItem item, double width, BuildContext context) {
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
            const SizedBox(
              width: 16,
              child: Icon(
                Icons.verified_outlined,
                size: 16,
                color: Colors.grey,
              ),
            )
          ],
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
