import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/chats/chat.dart';
import 'package:chat_app/screens/chats/chat_bloc.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:chat_app/screens/news/news.dart';
import 'package:chat_app/screens/news/news_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const main = '/';

  static const chat = 'chat';
  static const news = 'news';
  static const transcript = 'transcript';
  static const profile = 'settings/profile';

  bool isLogin = false;

  generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.main:
        (context) {
          return isLogin
              ? BlocProvider<TabBloc>(
                  create: (BuildContext context) => TabBloc(),
                  child: MainApp(navFromStart: true),
                )
              : BlocProvider<LoginBloc>(
                  create: (BuildContext context) => LoginBloc(context),
                  child: const LoginPage(),
                );
        };
        break;
      case AppRoutes.chat:
        (context) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ChatsBloc(context),
              child: const ChatsPage(),
            ),
          );
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
      default:
        return null;
    }
  }
}
