import 'package:chat_app/screens/chats/chat.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter/material.dart';

class CreateNewMessage extends StatefulWidget {
  final TextEditingController searchNewController;
  final FocusNode focusNode;
  final bool isAdmin;

  const CreateNewMessage({
    super.key,
    required this.searchNewController,
    required this.focusNode,
    required this.isAdmin,
  });

  @override
  State<CreateNewMessage> createState() => _CreateNewMessageState();
}

class _CreateNewMessageState extends State<CreateNewMessage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
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
                  bottom: 5,
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
                        print('go to on chatting');
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
                        style: TextStyle(fontSize: 14, color: Colors.blue[300]),
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
                    controller: widget.searchNewController,
                    onSubmitted: (_) => widget.focusNode.requestFocus(),
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
                child: widget.isAdmin
                    ? InkWell(
                        onTap: () {
                          //todo::::
                          print('create new group');
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
                  itemCount: itemList.length + 2,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 80),
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
                    return _createSuggestItem(itemList[index - 1]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSuggestItem(CustomListItem itemList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: SizedBox(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 40,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: CircleAvatar(
                child: Image.asset(
                  itemList.imageUrlAvt,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  itemList.name,
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
      ),
    );
  }
}
