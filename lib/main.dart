import 'dart:io';

import 'package:chat_app/routes.dart';
import 'package:chat_app/services/notification_services.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _removeBadgeWhenOpenApp();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Init SharedPreferences storage
  await SharedPreferencesStorage.init();

  runApp(MyApp(/*appTheme: AppTheme(),*/));
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

  MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) async {
      if (kDebugMode) {
        // print('device FCMToken: $value');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserLoggedInStatus() async {
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
      routes: AppRoutes().routes(context, isLoggedIn: _isLoggedIn),
    );
  }
}
