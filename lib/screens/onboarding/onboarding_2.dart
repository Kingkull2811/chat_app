import 'package:flutter/material.dart';

class OnBoarding2Page extends StatelessWidget {
  const OnBoarding2Page({
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
            'assets/images/image_onboarding_2.png',
            width: 350,
            height: 200,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text(
              'title of onboarding 2',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
