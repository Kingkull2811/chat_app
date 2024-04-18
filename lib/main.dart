import 'dart:io';

import 'package:chat_app/l10n/app_localizations/app_localizations.dart';
import 'package:chat_app/routes.dart';
import 'package:chat_app/services/notification_services.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _backgroundHandlerMessaging(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _removeBadgeWhenOpenApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_backgroundHandlerMessaging);
  await SharedPreferencesStorage.init();


  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Platform.isIOS ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: Brightness.dark, // status bar color
    ),
  );

    runApp(const MyApp());
}

_removeBadgeWhenOpenApp() async {
  bool osSupportBadge = await FlutterAppBadger.isAppBadgeSupported();
  if (osSupportBadge && Platform.isIOS) {
    FlutterAppBadger.removeBadge();
  }
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  FirebaseMessagingServices notificationService = FirebaseMessagingServices();

  @override
  void initState() {
    super.initState();
    notificationService.initLocalNotifications();
    notificationService.initializedNotification();
  }

  getUserLoggedInStatus() async {
    bool isLoggedOut = SharedPreferencesStorage().getLoggedOutStatus();
    bool isExpired = true;
    String passwordExpiredTime = SharedPreferencesStorage().getAccessTokenExpired();
    if (passwordExpiredTime.isNotEmpty) {
      try {
        if (DateTime.parse(passwordExpiredTime).isAfter(DateTime.now())) {
          isExpired = false;
        }
      } catch (_) {}

      if (!isExpired) {
        if (isLoggedOut) {
          setState(() {
            _isLoggedIn = false;
          });
        } else {
          setState(() {
            _isLoggedIn = true;
          });
        }
      } else {
        setState(() {
          _isLoggedIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromARGB(255, 120, 144, 156),
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: const Color.fromARGB(255, 26, 26, 26),
            displayColor: const Color.fromARGB(255, 26, 26, 26),
          ),
    );

    // String initialRoute = NotificationController.initialAction == null ? AppRoutes.main : AppRoutes.callPage;

    return MaterialApp(
      theme: theme,
      darkTheme: AppTheme().dark,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      //debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routes: AppRoutes().routes(context, isLoggedIn: _isLoggedIn),
      initialRoute: AppRoutes.main,// initialRoute,
    );
  }
}
