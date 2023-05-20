import 'package:flutter/material.dart';

import '../../theme.dart';

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
              'Information Exchange',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Text(
              'We understand the importance of effective communication between teachers and parents. Our app facilitates seamless information exchange, enabling teachers to share important updates, homework assignments, and upcoming assessments directly with parents. Parents can stay informed about their child\'s academic progress and provide necessary support.',
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
