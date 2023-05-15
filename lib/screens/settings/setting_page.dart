import 'package:chat_app/screens/settings/profile/profile.dart';
import 'package:chat_app/screens/settings/profile/profile_bloc.dart';
import 'package:chat_app/screens/settings/security/security.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/utils.dart';
import 'notification_sound/setting_notification.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Setting',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ButtonSwitchIcon(
              //   title: 'Night mode',
              //   onToggle: (value) {
              //     setState(() {
              //       SharedPreferencesStorage().setNightMode(value);
              //     });
              //   },
              //   value: SharedPreferencesStorage().getNightMode() ?? false,
              //   activeIcon: const Icon(
              //     Icons.nights_stay_outlined,
              //   ),
              //   inActiveIcon: const Icon(Icons.sunny),
              // ),
              _itemWithIcon(
                title: 'Profile',
                iconPath: '',
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ProfileBloc(context),
                        child: const ProfilePage(),
                      ),
                    ),
                  );
                },
              ),
              _itemWithIcon(
                title: 'Notification & Sound',
                iconPath: '',
                icon: Icons.notifications_active_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingNotificationPage(),
                    ),
                  );
                },
              ),
              // _itemWithIcon(
              //   title: 'Privacy & Safety',
              //   iconPath: 'assets/images/ic_shield.png',
              //   onTap: () {},
              // ),
              _itemWithIcon(
                title: 'Security',
                iconPath: '',
                icon: Icons.lock_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityPage(),
                    ),
                  );
                },
              ),
              _itemWithIcon(
                title: 'Legal & Policy',
                iconPath: '',
                icon: Icons.policy_outlined,
                onTap: () {},
              ),
              _itemWithIcon(
                hasColor: true,
                title: 'Logout',
                iconPath: '',
                icon: Icons.logout_outlined,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Do you want to log out ?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () async {
                              logout(context);
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.red700,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemWithIcon({
    required String title,
    required String iconPath,
    required Function() onTap,
    IconData? icon,
    bool hasColor = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: hasColor ? AppColors.red700 : Colors.black,
              ),
            ),
            isNullOrEmpty(icon)
                ? Image.asset(
                    iconPath,
                    height: 24,
                    width: 24,
                    color: hasColor ? AppColors.red700 : Colors.black,
                  )
                : Icon(
                    icon,
                    size: 24,
                    color: hasColor ? AppColors.red700 : Colors.black,
                  ),
          ],
        ),
      ),
    );
  }
}
