import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import './onboarding_2.dart';
import './onboarding_1.dart';
import './onboarding_3.dart';

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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: PageView(
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
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 50 + padding.bottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  count: 3,
                  controller: _pageController,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Theme.of(context).primaryColor,
                    dotColor: AppConstants().grey130,
                    expansionFactor: 2,
                    dotHeight: 15,
                    dotWidth: 15,
                    spacing: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
