import 'package:chat_app/routes.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helper/helper_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: AppConstants.apiKey,
            appId: AppConstants.appId,
            messagingSenderId: AppConstants.messagingSenderId,
            projectId: AppConstants.projectId));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp(
      //appTheme: AppTheme(),
      ));
}

class MyApp extends StatefulWidget {
  //final AppTheme appTheme;
  final navigatorKey = GlobalKey<NavigatorState>();

  MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

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
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
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
        theme: AppTheme().light,
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
        supportedLocales: const [
          Locale('en'),
          Locale('vi')
        ],
        //home: _isSignedIn ? const HomePage() : const LoginPage(),
        routes: {
          AppRoutes.main: (context) => BlocProvider<TabBloc>(
                create: (BuildContext context) => TabBloc(),
                child: MainApp(
                  navFromStart: true,
                ),
              ),
        });
  }
}
