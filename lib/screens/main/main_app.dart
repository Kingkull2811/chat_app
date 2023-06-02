import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chats/chat.dart';
import '../chats/chat_bloc.dart';
import '../chats/chat_event.dart';
import '../news/news.dart';
import '../news/news_bloc.dart';
import '../settings/setting_page.dart';
import '../transcript/transcript.dart';
import '../transcript/transcript_bloc.dart';

class MainApp extends StatefulWidget {
  /// use [currentTab] for back to page with bottom item index
  /// 0 - chat, 1 - news, 2 - transcript, 3- settings
  final int? currentTab;

  MainApp({key, this.currentTab}) : super(key: GlobalKey<MainAppState>());

  @override
  MainAppState createState() {
    // DatabaseService().mainKey = this.key as GlobalKey<State<StatefulWidget>>?;
    return MainAppState();
  }
}

class MainAppState extends State<MainApp>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final bool _isUser = SharedPreferencesStorage().getUserRole();

  StreamSubscription<ConnectivityResult>? _networkSubscription;

  int newChatBadge = 1;
  int newsBadge = 2;
  int newTranscriptBadge = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_networkSubscription != null) {
      _networkSubscription?.cancel();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: Future.wait([getChatBadge()]),
      builder: (context, snapshot) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: CupertinoTabScaffold(
            tabBar: tapBar(),
            tabBuilder: (context, index) => _handleScreenIndex(context, index),
          ),
        );
      },
    );
  }

  CupertinoTabBar tapBar() {
    return CupertinoTabBar(
      currentIndex: widget.currentTab ?? 0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Badge(
            showBadge: (newChatBadge > 0),
            badgeContent: Text(newChatBadge.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topEnd(top: -5, end: -8),
            child: Icon(
              Icons.message_outlined,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
          activeIcon: Badge(
            showBadge: (newChatBadge > 0),
            badgeContent: Text(
              newChatBadge.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topEnd(top: -5, end: -8),
            child: const Icon(
              Icons.message_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            showBadge: (newsBadge > 0),
            badgeContent: Text(
              newsBadge.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topEnd(top: -5, end: -8),
            child: Icon(
              Icons.feed_outlined,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
          activeIcon: Badge(
            showBadge: (newsBadge > 0),
            badgeContent: Text(
              newsBadge.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topEnd(top: -5, end: -8),
            child: const Icon(
              Icons.feed_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: _isUser
              ? Badge(
                  showBadge: (newTranscriptBadge > 0),
                  badgeContent: Text(
                    newTranscriptBadge.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  badgeStyle: const BadgeStyle(
                    badgeColor: Colors.red,
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                  ),
                  position: BadgePosition.topEnd(top: -5, end: -8),
                  child: Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    child: Image.asset(
                      'assets/images/ic_transcript.png',
                      width: 22,
                      height: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    'assets/images/ic_transcript.png',
                    width: 22,
                    height: 22,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
          activeIcon: _isUser
              ? Badge(
                  showBadge: (newTranscriptBadge > 0),
                  badgeContent: Text(
                    newTranscriptBadge.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  badgeStyle: const BadgeStyle(
                    badgeColor: Colors.red,
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                  ),
                  position: BadgePosition.topEnd(top: -5, end: -8),
                  child: Image.asset(
                    'assets/images/ic_transcript.png',
                    width: 30,
                    height: 30,
                    color: Colors.black,
                  ),
                )
              : Image.asset(
                  'assets/images/ic_transcript.png',
                  width: 30,
                  height: 30,
                  color: Colors.black,
                ),
          label: _isUser ? 'Transcript' : 'Manage',
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              'assets/images/ic_setting_outline.png',
              width: 22,
              height: 22,
              color: Theme.of(context).primaryColor,
            ),
          ),
          activeIcon: Image.asset(
            'assets/images/ic_setting_outline.png',
            width: 30,
            height: 30,
            color: Colors.black,
          ),
          label: 'Settings',
        ),
      ],
      activeColor: Colors.black,
      inactiveColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey[50],
      iconSize: 30,
      height: 50,
    );
  }

  _handleScreenIndex(BuildContext context, int index) {
    Widget currentTab;
    switch (index) {
      case 0:
        currentTab = BlocProvider(
          create: (context) => ChatsBloc(context)..add(ChatInit()),
          child: const ChatsPage(),
        );
        break;
      case 1:
        currentTab = BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(context),
          child: const NewsPage(),
        );
        break;
      case 2:
        currentTab = BlocProvider<TranscriptBloc>(
          create: (context) => TranscriptBloc(context),
          child: const TranscriptPage(),
        );
        break;
      case 3:
        currentTab = const SettingPage();
        break;
      default:
        currentTab = BlocProvider(
          create: (context) => ChatsBloc(context),
          child: const ChatsPage(),
        );
    }
    return currentTab;
  }

  // Update badge for bottom tab
  void reloadPage() {
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text(
              'Exit the app?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Are you sure you want to exit the app?',
                //Bạn có chắc chắn muốn thoát khỏi ứng dụng?
                style: TextStyle(fontSize: 14),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Exits',
                  style: TextStyle(
                    color: AppColors.red700,
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<int?> getChatBadge() async {
    int chatNumber = 2;
    return chatNumber;
  }

  Future<int> getNewsBadge() async {
    int reportNumber = 1;
    return reportNumber;
  }

  Future<int> getTranscriptBadge() async {
    int reportNumber = 2;
    return reportNumber;
  }

  Future<void> setAppBadge() async {
    bool osSupportBadge = await FlutterAppBadger.isAppBadgeSupported();
    if (osSupportBadge && Platform.isIOS) {
      int appBadgeNumber = newChatBadge + newsBadge + newTranscriptBadge;
      if (appBadgeNumber > 0) {
        FlutterAppBadger.updateBadgeCount(appBadgeNumber);
      } else {
        FlutterAppBadger.removeBadge();
      }
    }
  }

  Future<void> clearChatBadge() async {
    newChatBadge = 0;
    reloadPage();
    setAppBadge();
  }

  Future<void> clearNewsBadge() async {
    newsBadge = 0;
    reloadPage();
    setAppBadge();
  }

  Future<void> clearTranscriptBadge() async {
    newTranscriptBadge = 0;
    reloadPage();
    setAppBadge();
  }

  void clearAllBadge() {
    setState(() {
      newChatBadge = 0;
      newsBadge = 0;
      newTranscriptBadge = 0;
      reloadPage();
    });
  }
}
