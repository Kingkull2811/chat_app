import 'package:chat_app/screens/profile/profile.dart';
import 'package:chat_app/screens/profile/profile_bloc.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DrawerMenu extends StatelessWidget {
  final String imageUrl;
  final String name;
  final Function(bool) onTapNightMode;
  const DrawerMenu({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.onTapNightMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _headerDrawer(context),
              Divider(
                thickness: 0.5,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Column(
                  children: [
                    _drawerItemNightMode(context),
                    _drawerItem(
                      title: 'Notification & Sound',
                      iconPath: '',
                      icon: Icons.notifications_active_outlined,
                      onTap: () {},
                    ),
                    _drawerItem(
                      title: 'Privacy & Safety',
                      iconPath: 'assets/images/ic_shield.png',
                      onTap: () {},
                    ),
                    _drawerItem(
                      title: 'Security',
                      iconPath: '',
                      icon: Icons.lock_outline,
                      onTap: () {},
                    ),
                    _drawerItem(
                      title: 'Legal & Policy',
                      iconPath: '',
                      icon: Icons.policy_outlined,
                      onTap: () {},
                    ),
                    _drawerItem(
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
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black)),
                                  ),
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () async {
                                      logout(context);
                                    },
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppConstants().red700),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.5,
                color: Theme.of(context).primaryColor,
              ),
              _contact(context),
            ],
          ),
        ),
      ),
    );
  }

  _headerDrawer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(context),
                child: ProfilePage(
                  key: DatabaseService().profileKey,
                ),
              ),
            ),
          );
        },
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(
                radius: 25,
                child: Image.asset(imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _drawerItemNightMode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Night mode',
            maxLines: 1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          FlutterSwitch(
            width: 44.0,
            height: 24.0,
            toggleSize: 22.0,
            value: SharedPreferencesStorage().getNightMode() ?? false,
            borderRadius: 12.0,
            padding: 1.0,
            activeColor: const Color(0xFF81c784),
            inactiveColor: Theme.of(context).primaryColor,
            activeIcon: const Icon(Icons.nights_stay_outlined),
            inactiveIcon: const Icon(Icons.sunny),
            onToggle: onTapNightMode,
          ),
        ],
      ),
    );
  }

  _drawerItem({
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
                color: hasColor ? AppConstants().red700 : Colors.black,
              ),
            ),
            isNullOrEmpty(icon)
                ? Image.asset(
                    iconPath,
                    height: 24,
                    width: 24,
                    color: hasColor ? AppConstants().red700 : Colors.black,
                  )
                : Icon(
                    icon,
                    size: 24,
                    color: hasColor ? AppConstants().red700 : Colors.black,
                  ),
          ],
        ),
      ),
    );
  }

  _contact(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'The application is developed & designed by:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              'TRAN XUAN TRUONG',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              'CT030354',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const Text(
            'Contact: truongtran.dev@gmail.com',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
