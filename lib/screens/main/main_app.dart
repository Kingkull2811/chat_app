import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../main/tab/tab_bloc.dart';
import '../main/tab/tab_event.dart';
import '../main/tab/tab_selector.dart';
import '../news/news.dart';
import '../news/news_bloc.dart';
import '../profile/profile.dart';
import '../profile/profile_bloc.dart';
import '../transcript/transcript.dart';
import '../transcript/transcript_bloc.dart';
import '../chats/chat.dart';
import '../chats/chat_bloc.dart';
import '../../services/database.dart';

class MainApp extends StatefulWidget {
  final bool navFromStart;

  MainApp({key, this.navFromStart = false}) : super(key: GlobalKey<MainAppState>());

  @override
  MainAppState createState() {
    // DatabaseService().chatKey = this.key as GlobalKey<State<StatefulWidget>>?;
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
          return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
            _tabController?.index = AppTab.values.indexOf(activeTab);
            return Scaffold(
              body: _handleScreen(activeTab),
              bottomNavigationBar: TabSelector(
                  activeTab: activeTab,
                  newChatsBadgeNumber: 1,
                  newsBadgeNumber: 2,
                  newTranscriptBadgeNumber: 1,
                  onTabSelected: (tab) async {
                    // if (activeTab == AppTab.chat && tab != AppTab.chat) {
                    //   //todo:
                    //   if (kDebugMode) {
                    //     print('tab # chat');
                    //   }
                    // }
                    // if (tab == AppTab.chat) {
                    //   if (kDebugMode) {
                    //     print('tab chat');
                    //   }
                    // }
                    BlocProvider.of<TabBloc>(context).add(TabUpdated(tab));
                    setState(() {});
                  }),
            );
          });
        });
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
        currentTab = BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(context),
          child: ProfilePage(
            key: DatabaseService().profileKey,
          ),
        );
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

  Future<int?> getChatBadge() async {
    int chatNumber = 2;
    return chatNumber;
  }
}
