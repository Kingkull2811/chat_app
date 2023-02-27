import 'package:flutter/material.dart';

class OnBoarding1Page extends StatelessWidget {
  final Function()? onRightTap;
  const OnBoarding1Page({Key? key, this.onRightTap}) : super(key: key);

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
        children: [
          Image.asset('assets/images/image_onboarding_1.png'),
          const Padding(
            padding:  EdgeInsets.only(top: 50.0),
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
