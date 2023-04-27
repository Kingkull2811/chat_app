import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/chats/chat.dart';
import 'package:chat_app/screens/chats/chat_bloc.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/news/news.dart';
import 'package:chat_app/screens/news/news_bloc.dart';
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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.main:
        (context) {
          return getLoginStatus()
              ? MainApp()
              : BlocProvider<LoginBloc>(
                  create: (BuildContext context) => LoginBloc(context),
                  child: const LoginPage(),
                );
        };
        break;
      case AppRoutes.chat:
        (context) {
          return MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                    value: ChatsBloc(context),
                    child: const ChatsPage(),
                  ));
        };
        break;
      case AppRoutes.news:
        (context) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => NewsBloc(context),
              child: const NewsPage(),
            ),
          );
        };
        break;
    }
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
              body: Center(child: Text('No route defined')),
            ));
  }

  static getLoginStatus() {
    bool isLoggedOut = SharedPreferencesStorage().getLoggedOutStatus();
    bool isExpired = true;
    String passwordExpiredTime =
        SharedPreferencesStorage().getAccessTokenExpired();
    if (passwordExpiredTime.isNotEmpty) {
      try {
        if (DateTime.parse(passwordExpiredTime).isAfter(DateTime.now())) {
          isExpired = false;
        }
      } catch (_) {}

      if (!isExpired) {
        if (isLoggedOut) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    }
  }
}
