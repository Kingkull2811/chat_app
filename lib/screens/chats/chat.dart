import 'package:chat_app/screens/chats/chat_bloc.dart';
import 'package:chat_app/screens/chats/on_chatting/on_chatting.dart';
import 'package:chat_app/screens/chats/on_chatting/on_chatting_bloc.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
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

  final bool isAdmin = false;

  bool isNightMode = SharedPreferencesStorage().getNightMode() ?? false;

  late ChatsBloc _chatsBloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _chatsBloc = BlocProvider.of<ChatsBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _chatsBloc.close();
    _searchController.dispose();
    _searchNewMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.grey[50],
          leading: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(left: 16),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: builder))
              },
              child: const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/image_profile_1.png'),
              ),
            ),
          ),
          title: InkWell(
            onTap: () {
              // _scaffoldKey.currentState?.openDrawer();
            },
            child: const Text(
              'Chat',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  _createNewMessage(context);
                },
                child: Icon(
                  Icons.add_comment_outlined,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        body: ListView.separated(
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
          itemCount: itemList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _searchBox();
            }
            return _cardChat(context, itemList[index - 1]);
          },
        ),
        //drawerEnableOpenDragGesture: false,
        // drawer: DrawerMenu(
        //   imageUrl: 'assets/images/image_profile_1.png',
        //   name: 'Martha Craig',
        //   onTapNightMode: (value) {
        //     setState(() {
        //       isNightMode = !isNightMode;
        //       SharedPreferencesStorage().setNightMode(isNightMode);
        //     });
        //   },
        // ),
      );
    });
  }

  void reloadPage() {
    // BlocProvider.of<ChatsBloc>(context).add();
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onSubmitted: (_) => _focusNode.requestFocus(),
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
    );
  }

  _createNewMessage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (value) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.9,
          color: AppColors.grey630,
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
                    left: MediaQuery.of(context).size.width * 0.45,
                    top: 6,
                    right: MediaQuery.of(context).size.width * 0.45,
                    bottom: 10,
                  ),
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: isAdmin
                      ? InkWell(
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
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: itemList.length + 1,
                    separatorBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            color: Theme.of(context).primaryColor,
                            height: 0.5,
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 80, right: 16),
                        child: Divider(
                          color: Theme.of(context).primaryColor,
                          height: 0.5,
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 10, bottom: 10),
                          child: Text(
                            'Suggest',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Container(
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
                                    itemList[index - 1].imageUrlAvt,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    itemList[index - 1].name,
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
                                'email\nphone',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                              )
                            ],
                          ),
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
                child: OnChattingPage(item: item),
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
                        maxWidth: MediaQuery.of(context).size.width * 0.45),
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
