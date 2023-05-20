import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/settings/profile/profile.dart';
import 'package:chat_app/screens/settings/profile/profile_bloc.dart';
import 'package:chat_app/screens/settings/terms_policies/terms_policies.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const main = '/';

  static const chat = '/chat';
  static const news = '/news';
  static const transcript = '/transcript';
  static const setting = '/setting';
  static const profile = '/settings/profile';
  static const login = '/login';
  static const terms = '/settings/term_policy';

  Map<String, Widget Function(BuildContext)> routes(context,
      {required bool isLoggedIn}) {
    return {
      AppRoutes.main: (context) {
        return isLoggedIn
            ? MainApp(currentTab: 0)
            : BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(context),
                child: const LoginPage(),
              );
      },
      AppRoutes.chat: (context) {
        return MainApp(currentTab: 0);
      },
      AppRoutes.news: (context) {
        return MainApp(currentTab: 1);
      },
      AppRoutes.transcript: (context) {
        return MainApp(currentTab: 2);
      },
      AppRoutes.setting: (context) {
        return MainApp(currentTab: 3);
      },
      AppRoutes.profile: (context) {
        return BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(context),
          child: ProfilePage(userID: SharedPreferencesStorage().getUserId()),
        );
      },
      AppRoutes.login: (context) {
        return BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(context),
          child: const LoginPage(),
        );
      },
      AppRoutes.terms: (context) {
        return const TermPolicyPage();
      }
    };
  }
}
