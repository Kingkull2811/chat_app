import 'package:chat_app/network/model/user_from_firebase.dart';
import 'package:chat_app/routes.dart';
import 'package:chat_app/screens/chats/chat_bloc.dart';
import 'package:chat_app/screens/chats/chat_event.dart';
import 'package:chat_app/screens/chats/chat_state.dart';
import 'package:chat_app/screens/chats/tab/chat_tab.dart';
import 'package:chat_app/screens/chats/tab/contact_tab.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/screen_utilities.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _searchNewMessageController = TextEditingController();

  final bool isAdmin = SharedPreferencesStorage().getAdminRole() ||
      SharedPreferencesStorage().getTeacherRole();

  late ChatsBloc _chatsBloc;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _chatsBloc = BlocProvider.of<ChatsBloc>(context)..add(ChatInit());
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatsBloc.close();
    _searchNewMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsBloc, ChatsState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(
            context,
            'Error!',
            content: 'Internal Server Error',
            // onCloseDialog: () {
            //   reloadPage();
            // },
          );
        }
      },
      builder: (context, state) {
        Widget body = const SizedBox.shrink();
        if (state.isLoading) {
          body = const AnimationLoading();
        } else {
          body = _body(context, state);
        }
        return body;
      },
    );
  }

  Widget _body(BuildContext context, ChatsState state) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _appBar(state.userData),
        body: TabBarView(
          controller: _tabController,
          children: [
            ChatTab(),
            ContactTab(listUser: state.listUser),
          ],
        ),
      ),
    );
  }

  void reloadPage() {
    _chatsBloc.add(ChatInit());
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
                      onSubmitted: (_) {},
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
                // Expanded(
                //   child: ListView.separated(
                //     physics: const BouncingScrollPhysics(),
                //     itemCount: itemList.length + 1,
                //     separatorBuilder: (context, index) {
                //       if (index == 0) {
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 16),
                //           child: Divider(
                //             color: Theme.of(context).primaryColor,
                //             height: 0.5,
                //           ),
                //         );
                //       }
                //       return Padding(
                //         padding: const EdgeInsets.only(left: 80, right: 16),
                //         child: Divider(
                //           color: Theme.of(context).primaryColor,
                //           height: 0.5,
                //         ),
                //       );
                //     },
                //     itemBuilder: (context, index) {
                //       if (index == 0) {
                //         return Padding(
                //           padding: const EdgeInsets.only(
                //               left: 16, top: 10, bottom: 10),
                //           child: Text(
                //             'Suggest',
                //             style: TextStyle(
                //               fontSize: 14,
                //               color: Theme.of(context).primaryColor,
                //             ),
                //           ),
                //         );
                //       }
                //       return Padding(
                //         padding: const EdgeInsets.only(top: 6, bottom: 6),
                //         child: Container(
                //           height: 50,
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 16, vertical: 5),
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: <Widget>[
                //               Container(
                //                 width: 40,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(20)),
                //                 child: CircleAvatar(
                //                   child: Image.asset(
                //                     itemList[index - 1].imageUrlAvt,
                //                   ),
                //                 ),
                //               ),
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.only(left: 10),
                //                   child: Text(
                //                     itemList[index - 1].name,
                //                     style: const TextStyle(
                //                       fontSize: 20,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.black,
                //                     ),
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis,
                //                   ),
                //                 ),
                //               ),
                //               Text(
                //                 'email\nphone',
                //                 style: TextStyle(
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.normal,
                //                   color: Theme.of(context).primaryColor,
                //                 ),
                //               ),
                //               const Padding(
                //                 padding: EdgeInsets.only(left: 10),
                //               )
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(UserFirebaseData? userData) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.grey[50],
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
        child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
                child: AppImage(
                  isOnline: true,
                  localPathOrUrl: userData?.fileUrl,
                  boxFit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorWidget: Image.asset(
                    'assets/images/ic_account_circle.png',
                    color: Colors.grey.withOpacity(0.6),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
      ),
      centerTitle: true,
      title: Container(
        height: 40,
        width: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[50],
            border: Border.all(
              width: 1,
              color: Theme.of(context).primaryColor,
            )),
        child: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          labelStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          indicatorWeight: 0,
          indicatorColor: Colors.black,
          indicator: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Contact'),
          ],
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
    );
  }
}
