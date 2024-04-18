import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/images/app_logo_light.png'),
          const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text(
              AppConstants.appName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
