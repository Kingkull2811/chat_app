import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:chat_app/screens/main/tab/tab_event.dart';
import 'package:chat_app/screens/main/tab/tab_selector.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/app_constants.dart';

class MainApp extends StatefulWidget {
  final bool navFromStart;

  const MainApp({key, this.navFromStart = false}) : super(key: GlobalKey<MainAppState>());

  @override
  MainAppState createState() {
    DatabaseService().chatKey = this.key as GlobalKey<State<StatefulWidget>>?;
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState(){
    _tabController = TabController(length: AppTab.values.length, vsync: this);
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: Future.wait([getReportBadge()]),
        builder: (context, snapshot) {
          return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
            _tabController?.index = AppTab.values.indexOf(activeTab);
            return Scaffold(
              body: _handleScreen(activeTab),
              bottomNavigationBar: TabSelector(
                  activeTab: activeTab,
                  badgeNumber: snapshot.hasData ? snapshot.data[0] : 0,
                  newModelBadgeNumber:
                  newModelBadgeNumber + newVersionBadgeNumber,
                  newFeedbackBadgeNumber: newFeedbackBadgeNumber,
                  onTabSelected: (tab) async {
                    if (activeTab == AppTab.chat &&
                        tab != AppTab.chat) {
                    }
                    if (tab == AppTab.home) {
                      checkNewAnnouncement();
                    }
                    BlocProvider.of<TabBloc>(context).add(TabUpdated(tab));
                    setState(() {});
                  }),
            );
          });
        });
  }
}
