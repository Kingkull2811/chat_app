import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tab_event.dart';

class TabSelector extends StatefulWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;
  final int newChatsBadgeNumber;
  final int newsBadgeNumber;
  final int newTranscriptBadgeNumber;

  const TabSelector({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
    required this.newChatsBadgeNumber,
    required this.newsBadgeNumber,
    required this.newTranscriptBadgeNumber,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TabSelectorState();
}

class TabSelectorState extends State<TabSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      currentIndex: AppTab.values.indexOf(widget.activeTab),
      onTap: (index) {
        widget.onTabSelected(AppTab.values[index]);
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Badge(
            showBadge: (widget.newChatsBadgeNumber > 0),
            badgeContent: Text((widget.newChatsBadgeNumber.toString()),
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
            showBadge: (widget.newChatsBadgeNumber > 0),
            badgeContent: Text(
              widget.newChatsBadgeNumber.toString(),
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
            showBadge: (widget.newsBadgeNumber > 0),
            badgeContent: Text(
              widget.newsBadgeNumber.toString(),
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
            showBadge: (widget.newsBadgeNumber > 0),
            badgeContent: Text(
              widget.newsBadgeNumber.toString(),
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
          icon: Badge(
            showBadge: (widget.newTranscriptBadgeNumber > 0),
            badgeContent: Text(
              widget.newTranscriptBadgeNumber.toString(),
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
          ),
          activeIcon: Badge(
            showBadge: (widget.newTranscriptBadgeNumber > 0),
            badgeContent: Text(
              widget.newTranscriptBadgeNumber.toString(),
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
          ),
          label: 'Transcript',
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
      // selectedLabelStyle: const TextStyle(
      //   fontSize: 10,
      //   fontWeight: FontWeight.bold,
      //   color: Colors.black,
      // ),
      // unselectedLabelStyle: TextStyle(
      //   fontSize: 10,
      //   fontWeight: FontWeight.bold,
      //   color: Theme.of(context).primaryColor,
      // ),
      // unselectedItemColor: Theme.of(context).primaryColor,
      // selectedItemColor: Colors.black,
      // showUnselectedLabels: true,
      // type: BottomNavigationBarType.fixed,
      // selectedFontSize: 12,
    );
  }
}
