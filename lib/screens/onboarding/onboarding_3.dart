import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoarding3Page extends StatelessWidget {
  const OnBoarding3Page({
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/image_onboarding_3.png',
                  height: 200,
                  width: 350,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'title of onboarding 3',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 100 + padding.bottom),
            child: PrimaryButton(
              text: 'Next',
              onTap: () async {
                showLoading(context);
                const Duration(milliseconds: 500);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<TabBloc>(
                      create: (context) => TabBloc(),
                      child: MainApp(navFromStart: true),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
