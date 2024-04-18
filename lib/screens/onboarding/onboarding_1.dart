import 'package:chat_app/l10n/l10n.dart';
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
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Text(
              context.l10n.onboardingTitle1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Text(
              context.l10n.onboardingContent1 + context.l10n.onboardingContent11,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
