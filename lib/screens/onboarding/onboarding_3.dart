import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/shared_preferences_storage.dart';
import '../authenticator/fill_profile/fill_profile.dart';
import '../authenticator/fill_profile/fill_profile_bloc.dart';

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
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text(
                    context.l10n.onboardingTitle3,
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
                    context.l10n.onboardingContent3 + context.l10n.onboardingContent33,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 100 + padding.bottom),
            child: PrimaryButton(
              text: context.l10n.next,
              onTap: () async {
                showLoading(context);
                final userInfo = await AuthRepository().getUserInfo(userId: SharedPreferencesStorage().getUserId());

                if (userInfo is UserInfoModel) {
                  await SharedPreferencesStorage().setFullName(userInfo.fullName ?? '');
                  await SharedPreferencesStorage().setImageAvatarUrl(userInfo.fileUrl ?? '');
                  userInfo.isFillProfileKey ? _navigateToMainPage() : _navigateToFillProfilePage(userInfo);
                } else {
                  // log(userInfo.toString());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _navigateToFillProfilePage(UserInfoModel userInfo) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<FillProfileBloc>(
            create: (context) => FillProfileBloc(context),
            child: FillProfilePage(userInfo: userInfo),
          ),
        ),
        // (route) => true,
      );

  _navigateToMainPage() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainApp(currentTab: 0)),
      );
}
