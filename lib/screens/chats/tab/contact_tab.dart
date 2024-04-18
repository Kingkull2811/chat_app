import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/network/model/user_from_firebase.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/permission.dart';
import '../../../utilities/call_utils.dart';
import '../../../utilities/enum/call_type.dart';
import '../../settings/profile/profile.dart';
import '../../settings/profile/profile_bloc.dart';
import '../chat_room/message_view.dart';

class ContactTab extends StatefulWidget {
  final List<UserFirebaseData>? listUser;

  const ContactTab({Key? key, this.listUser}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  final _searchController = TextEditingController();

  bool _showSearchResult = false;

  List<UserFirebaseData> listUsers = [];

  final _pref = SharedPreferencesStorage();

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
      onTap: () => FocusScope.of(context).focusedChild?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _searchBox(context),
              Expanded(
                child: _listView(_showSearchResult ? listUsers : widget.listUser),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listView(List<UserFirebaseData>? listUserData) {
    if (isNullOrEmpty(listUserData)) {
      return Center(
        child: Text( context.l10n.noContact,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor
          ),
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
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.4)),
            bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.4)),
          ),
        ),
        child: InkWell(
          onTap: () {
            if (item.id == null) {
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<ProfileBloc>(
                  create: (context) => ProfileBloc(context),
                  child: ProfilePage(userID: item.id!),
                ),
              ),
            );
          },
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
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
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
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        item.phone ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
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
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Icon(
                        Icons.message_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async => await PermissionsServices.microphonePermissionsGranted()
                        ? CallUtils.dialVoice(
                            context: context,
                            isFromChat: false,
                            callerId: _pref.getUserId().toString(),
                            callerName: _pref.getFullName(),
                            callerPic: _pref.getImageAvatarUrl(),
                            callerFCMToken: await FirebaseMessaging.instance.getToken(),
                            receiverId: item.id.toString(),
                            receiverName: item.fullName ?? '',
                            receiverPic: item.fileUrl ?? '',
                            receiverFCMToken: item.fcmToken,
                            callType: CallType.audioCall,
                          )
                        : {},
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Icon(
                        Icons.call,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
