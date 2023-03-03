import 'package:flutter/material.dart';

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
              'title of onboarding 1',
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
