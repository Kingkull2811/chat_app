import 'dart:async';
import 'dart:io';

import 'package:chat_app/theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/database.dart';
import '../chats/chat.dart';
import '../chats/chat_bloc.dart';
import '../main/tab/tab_bloc.dart';
import '../main/tab/tab_event.dart';
import '../main/tab/tab_selector.dart';
import '../news/news.dart';
import '../news/news_bloc.dart';
import '../settings/setting_page.dart';
import '../transcript/transcript.dart';
import '../transcript/transcript_bloc.dart';

class MainApp extends StatefulWidget {
  final bool navFromStart;

  MainApp({key, this.navFromStart = false})
      : super(key: GlobalKey<MainAppState>());

  @override
  MainAppState createState() {
    // DatabaseService().mainKey = this.key as GlobalKey<State<StatefulWidget>>?;
    return MainAppState();
  }
}

class MainAppState extends State<MainApp>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  StreamSubscription<ConnectivityResult>? _networkSubscription;
  int newChatBadge = 0;
  int newsBadge = 0;
  int newTranscriptBadge = 0;

  @override
  void initState() {
    _tabController = TabController(length: AppTab.values.length, vsync: this);
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
        return BlocBuilder<TabBloc, AppTab>(
          builder: (context, activeTab) {
            _tabController?.index = AppTab.values.indexOf(activeTab);
            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                body: _handleScreen(activeTab),
                bottomNavigationBar: TabSelector(
                  activeTab: activeTab,
                  newChatsBadgeNumber: 1,
                  newsBadgeNumber: 2,
                  newTranscriptBadgeNumber: 1,
                  onTabSelected: (tab) async {
                    BlocProvider.of<TabBloc>(context).add(TabUpdated(tab));
                    setState(() {});
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  _handleScreen(AppTab activeTab) {
    Widget currentTab;
    switch (activeTab) {
      case AppTab.chat:
        currentTab = BlocProvider(
          create: (context) => ChatsBloc(context),
          child: ChatsPage(
            key: DatabaseService().chatKey,
          ),
        );
        break;
      case AppTab.news:
        currentTab = BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(context),
          child: NewsPage(
            key: DatabaseService().newsKey,
          ),
        );
        break;
      case AppTab.transcript:
        currentTab = BlocProvider<TranscriptBloc>(
          create: (context) => TranscriptBloc(context),
          child: TranscriptPage(
            key: DatabaseService().transcriptKey,
          ),
        );
        break;
      case AppTab.profile:
        currentTab = const SettingPage();
        break;
      default:
        currentTab = BlocProvider(
          create: (context) => ChatsBloc(context),
          child: ChatsPage(
            key: DatabaseService().chatKey,
          ),
        );
    }
    return currentTab;
  }

  // Update badge for bottom tab
  void reloadPage() {
    setState(() {});
  }

  void changeTabToChat() {
    BlocProvider.of<TabBloc>(context).add(const TabUpdated(AppTab.chat));
  }

  void changeTabToNews() {
    BlocProvider.of<TabBloc>(context).add(const TabUpdated(AppTab.news));
  }

  void changeTabToTranscript() {
    BlocProvider.of<TabBloc>(context).add(const TabUpdated(AppTab.transcript));
  }

  void changeTabToProfile() {
    BlocProvider.of<TabBloc>(context).add(const TabUpdated(AppTab.profile));
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
