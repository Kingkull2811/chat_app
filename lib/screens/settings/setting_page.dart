import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/routes.dart';
import 'package:chat_app/screens/settings/security/security.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
        title: Text(
          context.l10n.settings,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
              _profile(),

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
              // _itemWithIcon(
              //   title: 'Notification & Sound',
              //   iconPath: '',
              //   icon: Icons.notifications_active_outlined,
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const SettingNotificationPage(),
              //       ),
              //     );
              //   },
              // ),
              // _itemWithIcon(
              //   title: 'Privacy & S/**/afety',
              //   iconPath: 'assets/images/ic_shield.png',
              //   onTap: () {},
              // ),
              _itemWithIcon(
                title: context.l10n.security,
                iconPath: '',
                icon: Icons.lock_outline,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityPage()));
                },
              ),
              _itemWithIcon(
                title: context.l10n.terms,
                iconPath: '',
                icon: Icons.policy_outlined,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.terms);
                },
              ),
              _itemWithIcon(
                hasColor: true,
                title: context.l10n.logout,
                iconPath: '',
                icon: Icons.logout_outlined,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          context.l10n.logout,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            context.l10n.wantLogout,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              context.l10n.cancel,
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () async {
                              logout(context);
                            },
                            child: Text(
                              context.l10n.logout,
                              style: const TextStyle(fontSize: 14, color: AppColors.red700),
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

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.profile);
        },
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(width: 0.1, color: AppColors.greyLight),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: AppImage(
                            isOnline: true,
                            localPathOrUrl: SharedPreferencesStorage().getImageAvatarUrl(),
                            boxFit: BoxFit.cover,
                            errorWidget: SizedBox(
                              height: 80,
                              width: 80,
                              child: Image.asset(
                                'assets/images/ic_account_circle.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _itemText(
                                'Username:',
                                '@${SharedPreferencesStorage().getUserName()}',
                              ),
                              _itemText(
                                'Email:',
                                SharedPreferencesStorage().getUserEmail(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.navigate_next,
                        size: 24,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
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
