import 'package:flutter/material.dart';

import '../../theme.dart';

class OnBoarding1Page extends StatelessWidget {
  const OnBoarding1Page({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: padding.top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/image_onboarding_1.png',
            height: 200,
            width: 350,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text(
              'Learning Results Tracking',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Text(
              'Our app allows teachers to easily record and track student\'s learning outcomes. Teachers can assess individual progress, identify areas of improvement, and tailor their teaching strategies accordingly. With comprehensive analytics and visualizations, educators can gain valuable insights into student performance.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
