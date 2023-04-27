import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../utilities/shared_preferences_storage.dart';

class SettingNotificationPage extends StatefulWidget {
  const SettingNotificationPage({Key? key}) : super(key: key);

  @override
  State<SettingNotificationPage> createState() =>
      _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  bool showMoreSound = false;
  bool showMoreNotification = false;

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 24,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Notification & Sound',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _itemWithButtonSwitch(
                title: 'Turn on the notification',
                value: SharedPreferencesStorage().getNightMode() ?? false,
                onToggle: (value) {
                  setState(() {
                    SharedPreferencesStorage().setNightMode(value);
                  });
                },
              ),
              _itemWithButtonSwitch(
                title: 'Turn on the notification preview',
                value: SharedPreferencesStorage().getPreviewNotification() ??
                    false,
                onToggle: (value) {
                  setState(() {
                    SharedPreferencesStorage().setPreviewNotification(value);
                  });
                },
              ),
              _itemWithButtonSwitch(
                title: 'Vibrate when a call coming',
                value: SharedPreferencesStorage().getVibrateMode() ?? false,
                onToggle: (value) {
                  setState(() {
                    SharedPreferencesStorage().setVibrateMode(value);
                  });
                },
              ),
              _itemSound(
                isShow: SharedPreferencesStorage().getNightMode() ?? false,
              ),
              _itemLockScreen(
                isShow: SharedPreferencesStorage().getPreviewNotification() ??
                    false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemWithButtonSwitch({
    required String title,
    required Function(bool) onToggle,
    required bool value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: FlutterSwitch(
              width: 40.0,
              height: 20.0,
              toggleSize: 18.0,
              value: value,
              borderRadius: 10.0,
              padding: 1.0,
              activeColor: const Color(0xFF81c784),
              inactiveColor: Theme.of(context).primaryColor,
              // activeIcon: const Icon(Icons.nights_stay_outlined),
              // inactiveIcon: const Icon(Icons.sunny),
              onToggle: onToggle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemSound({
    bool isShow = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              showMoreSound = !showMoreSound;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Sound',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: isShow ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    showMoreSound ? Icons.expand_more : Icons.navigate_next,
                    size: 24,
                    color: isShow ? Colors.black : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
        showMoreSound
            ? Container(
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _itemOnSound(
                        title: 'Incoming message sound',
                        content: '__sound__',
                        isShow: isShow,
                      ),
                      _itemOnSound(
                        title: 'Incoming call waiting sound',
                        content: '_content',
                        isShow: isShow,
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _itemOnSound({
    required String title,
    required String content,
    Function()? onTap,
    bool isShow = false,
  }) {
    return InkWell(
      onTap: isShow ? onTap : null,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: isShow ? Colors.black : Colors.grey[400],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: isShow ? Colors.black : Colors.grey[400],
              ),
            ),
          ),
          trailing: Icon(
            Icons.navigate_next,
            size: 24,
            color: isShow ? Colors.black : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _itemLockScreen({
    bool isShow = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              showMoreNotification = !showMoreNotification;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Notifications on lock screen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: isShow ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    showMoreNotification
                        ? Icons.expand_more
                        : Icons.navigate_next,
                    size: 24,
                    color: isShow ? Colors.black : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
        showMoreNotification
            ? Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
