import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoarding3Page extends StatelessWidget {
  final Function()? onLeftTap;

  const OnBoarding3Page({Key? key, this.onLeftTap}) : super(key: key);

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
              children: [
                Image.asset('assets/images/image_onboarding_3.png'),
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
            padding: EdgeInsets.only(bottom: 60 + padding.bottom),
            child: PrimaryButton(
              text: 'Next',
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<TabBloc>(
                      create: (context) => TabBloc(),
                      child: MainApp(
                        navFromStart: true,
                      ),
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
