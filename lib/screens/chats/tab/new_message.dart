import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/network/model/student_firebase.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../network/model/user_from_firebase.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/app_image.dart';
import '../chat_room/message_view.dart';

class NewMessage extends StatefulWidget {
  final List<UserFirebaseData>? listUser;

  const NewMessage({Key? key, this.listUser}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _searchController = TextEditingController();

  bool _showSearchResult = false;

  List<UserFirebaseData> listUsers = [];

  @override
  void initState() {
    listUsers = widget.listUser ?? [];
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, size: 24, color: Colors.white)),
          centerTitle: true,
          title: Text(
            context.l10n.createMessage,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            _searchBox(context),
            Expanded(
              child: _listView(_showSearchResult ? listUsers : widget.listUser),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listView(List<UserFirebaseData>? listUserData) {
    if (isNullOrEmpty(listUserData)) {
      return Center(
        child: Text(
          context.l10n.noContact,
          style: const TextStyle(fontSize: 16, color: AppColors.primaryColor),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: listUserData!.length,
      itemBuilder: (context, index) => _createItemUser(listUserData[index]),
    );
  }

  Widget _createItemUser(UserFirebaseData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 80,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(width: 1, color: AppColors.primaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: AppImage(
                            isOnline: true,
                            localPathOrUrl: item.fileUrl,
                            boxFit: BoxFit.cover,
                            errorWidget: Image.asset(
                              'assets/images/ic_account_circle.png',
                              color: Colors.grey.withOpacity(0.6),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            item.fullName ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item.email ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            item.phone ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessageView(
                                receiverId: item.id.toString(),
                                receiverName: item.fullName ?? '',
                                receiverAvt: item.fileUrl ?? '',
                                receiverFCMToken: item.fcmToken ?? '',
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          CupertinoIcons.chat_bubble_text,
                          size: 34,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(75),
                                    border: Border.all(width: 1, color: AppColors.primaryColor),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(75),
                                    child: AppImage(
                                      isOnline: true,
                                      localPathOrUrl: item.fileUrl,
                                      boxFit: BoxFit.cover,
                                      errorWidget: Image.asset(
                                        'assets/images/ic_account_circle.png',
                                        color: Colors.grey.withOpacity(0.6),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${context.l10n.name} ${item.fullName}'),
                                  Text('${context.l10n.email}: ${item.email}'),
                                  Text('${context.l10n.tel} ${item.phone}'),
                                  Text(context.l10n.parentOf),
                                  _userInfoDialog(item.parentOf),
                                ],
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(context.l10n.ok),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Icon(CupertinoIcons.ellipsis_vertical, size: 24, color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  Widget _userInfoDialog(List<StudentFirebase>? student) {
    if (isNullOrEmpty(student)) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 90 * (student!.length).toDouble(),
      child: ListView.builder(
        itemCount: student.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
            child: Container(
              height: 80,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: AppColors.primaryColor)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 2, 0, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SSID: ${student[index].studentId}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${context.l10n.name} ${student[index].studentName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${context.l10n.dob}: ${student[index].dob}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${context.l10n.classTitle} ${student[index].className}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _searchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: _searchController,
          onFieldSubmitted: (value) {},
          onChanged: (value) {
            _search(value);
          },
          decoration: InputDecoration(
            hintText: context.l10n.search,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
            prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(width: 1, color: AppColors.primaryColor),
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

  void _search(String searchQuery) {
    if (searchQuery.isEmpty) {
      setState(() {
        listUsers = widget.listUser ?? [];
      });
    }
    List<UserFirebaseData> suggestion = widget.listUser?.where((user) {
          bool matchesFullName = user.fullName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
          bool matchesEmail = user.email?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
          bool matchesPhone = user.phone?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
          bool matchesParentClassName = user.parentOf?.any((student) => student.className?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ?? false;

          return matchesFullName || matchesEmail || matchesPhone || matchesParentClassName;
        }).toList() ??
        [];
    setState(() {
      listUsers = suggestion;
    });
  }
}
