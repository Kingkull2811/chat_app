import 'dart:io';
import 'package:chat_app/routes.dart';
import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/chats/chat.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:chat_app/screens/news/news.dart';
import 'package:chat_app/screens/profile/profile.dart';
import 'package:chat_app/screens/transcript/transcript.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _removeBadgeWhenOpenApp();

  //init global key for tabs
  DatabaseService().chatKey = GlobalKey<ChatsPageState>();
  DatabaseService().newsKey = GlobalKey<NewsPageState>();
  DatabaseService().transcriptKey = GlobalKey<TranscriptPageState>();
  DatabaseService().profileKey = GlobalKey<ProfilePageState>();

  // Init SharedPreferences storage
  await SharedPreferencesStorage.init();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: AppConstants.apiKey,
        appId: AppConstants.appId,
        messagingSenderId: AppConstants.messagingSenderId,
        projectId: AppConstants.projectId,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp(
      //appTheme: AppTheme(),
      ));
}

_removeBadgeWhenOpenApp() async {
  bool osSupportBadge = await FlutterAppBadger.isAppBadgeSupported();
  if (osSupportBadge && Platform.isIOS) {
    FlutterAppBadger.removeBadge();
  }
}

class MyApp extends StatefulWidget {
  //final AppTheme appTheme;
  final navigatorKey = GlobalKey<NavigatorState>();

  // final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool? _isLoggedOut = SharedPreferencesStorage().getLoggedOutStatus();

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserLoggedInStatus() async {
    // await HelperFunctions.getUserLoggedInStatus().then((value) {
    //   if (value != null) {
    //     setState(() {
    //       _isSignedIn = value;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      primaryColor:
          const Color.fromARGB(255, 120, 144, 156), //hex color #78909c
      backgroundColor: Colors.white,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: const Color.fromARGB(255, 26, 26, 26),
            displayColor: const Color.fromARGB(255, 26, 26, 26),
          ),
    );

    return MaterialApp(
      //theme: AppTheme().light,
      theme: theme,
      darkTheme: AppTheme().dark,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      //debugShowCheckedModeBanner: false,
      navigatorKey: widget.navigatorKey,
      localizationsDelegates: const [
        //AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
      routes: {
        AppRoutes.main: (context) {
          if (_isLoggedOut == null || _isLoggedOut == true) {
            return BlocProvider<LoginBloc>(
              create: (BuildContext context) => LoginBloc(),
              child: const LoginPage(),
            );
          } else {
            return BlocProvider<TabBloc>(
              create: (BuildContext context) => TabBloc(),
              child: MainApp(navFromStart: true),
            );
          }
        }
      },
    );
  }
}
