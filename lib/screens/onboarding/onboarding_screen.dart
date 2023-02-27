import 'package:chat_app/screens/onboarding/onboarding_1.dart';
import 'package:chat_app/screens/onboarding/onboarding_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/tab/tab_bloc.dart';
import 'onboarding_2.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
            children: [
              OnBoarding1Page(),
              OnBoarding2Page(),
              OnBoarding3Page(),
            ],
          ),
          Positioned(child: Padding(
            padding: EdgeInsets.all(5),
          ),),
        ],
      ),
    );
  }
}
