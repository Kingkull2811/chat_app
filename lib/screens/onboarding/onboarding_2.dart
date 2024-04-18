import 'package:chat_app/l10n/l10n.dart';
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
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Text(
              context.l10n.onboardingTitle2,
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
              context.l10n.onboardingContent2 + context.l10n.onboardingContent22,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
