import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/shared_preferences_storage.dart';
import '../settings/fill_profile/fill_profile.dart';
import '../settings/fill_profile/fill_profile_bloc.dart';
import '../settings/fill_profile/fill_profile_event.dart';

class OnBoarding3Page extends StatefulWidget {
  const OnBoarding3Page({
    Key? key,
  }) : super(key: key);

  @override
  State<OnBoarding3Page> createState() => _OnBoarding3PageState();
}

class _OnBoarding3PageState extends State<OnBoarding3Page> {
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
                final userInfo = await AuthRepository().getUserInfo(
                  userId: SharedPreferencesStorage().getUserId(),
                );
                if (userInfo is UserInfoModel) {
                  if (!mounted) {}
                  const Duration(milliseconds: 500);
                  userInfo.isFillProfileKey == true
                      ? _navigateToMainPage()
                      : _navigateToFillProfilePage(userInfo);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _navigateToFillProfilePage(UserInfoModel userInfo) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<FillProfileBloc>(
          create: (context) => FillProfileBloc(context)..add(FillInit()),
          child: FillProfilePage(userInfo: userInfo),
        ),
      ),
    );
  }

  _navigateToMainPage() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainApp(currentTab: 0)),
      );
}
