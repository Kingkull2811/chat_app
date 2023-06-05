import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:chat_app/routes.dart';
import 'package:chat_app/services/awesome_notification.dart';
import 'package:chat_app/services/notification_services.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/rxdart.dart';

import 'network/model/received_notification_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<NotificationResponse> selectNotificationSubject =
    BehaviorSubject<NotificationResponse>();

NotificationAppLaunchDetails? notificationAppLaunchDetails;
dynamic payloadReceived;

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'kull_chat', // id
  'kull_chat', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

configureFirebaseMessaging() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional) {
    NotificationServices.subscribeTopicForCurrentUser();
  } else {
    if (kDebugMode) {
      print('User declined or has not accepted permission');
    }
  }

  /// Create an Android Notification Channel.
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
}

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await configureFirebaseMessaging();
    _removeBadgeWhenOpenApp();

    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize cho Local Notification
    await AwesomeNotification.initializeLocalNotifications();

    // Initialize cho Push Notification
    await AwesomeNotification.initializeRemoteNotifications();
    // await AwesomeNotification.interceptInitialCallActionRequest();

    // Init SharedPreferences storage
    await SharedPreferencesStorage.init();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) async {
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        payloadReceived = payload;
        selectNotificationSubject.add(payload);
      },
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness:
            Platform.isIOS ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: Brightness.dark, // status bar color
      ),
    );

    ///--------crashlytics-----------
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);

    // When Crashlytics enabled, pass uncaught errors to Crashlytics Console
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      // Pass all uncaught errors to Crashlytics.

      FlutterError.onError = (FlutterErrorDetails errorDetails) async {
        await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      };

      //To catch errors that happen outside of the Flutter context, install an error listener on the current Isolate
      Isolate.current.addErrorListener(RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort);
    }

    runApp(const MyApp(/*appTheme: AppTheme(),*/));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

_removeBadgeWhenOpenApp() async {
  bool osSupportBadge = await FlutterAppBadger.isAppBadgeSupported();
  if (osSupportBadge && Platform.isIOS) {
    FlutterAppBadger.removeBadge();
  }
}

class MyApp extends StatefulWidget {
  //final AppTheme appTheme;
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
    AwesomeNotification().checkPermission();
    AwesomeNotification().requestFirebaseToken();
    // AwesomeNotification.initializeNotificationsEventListeners();

    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    _handleOpenRemoteNotificationWhenTerminated();
    _handleOpenRemoteNotification();
    _handleFirebaseMessagingOnMessage();
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

    String initialRoute = AwesomeNotification.initialCallAction == null
        ? AppRoutes.main
        : AppRoutes.callPage;

    return MaterialApp(
      //theme: AppTheme().light,
      theme: theme,
      darkTheme: AppTheme().dark,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      navigatorKey: MyApp.navigatorKey,
      localizationsDelegates: const [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
      routes: AppRoutes().routes(context, isLoggedIn: _isLoggedIn),
      initialRoute: initialRoute,
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) async {
      if (kDebugMode) {
        print(
            'Got a message whilst in the _configureSelectNotificationSubject!');
        print('Message data: $payload');
      }

      int? sessionId = int.tryParse(payload.id.toString());
      if (sessionId != null) {
        //todo
      } else {
        String url = payload.payload ?? '';
        if (url.startsWith('http') &&
            MyApp.navigatorKey.currentState?.context != null) {
          //todo
        } else if (url.contains("destination_screen")) {
          String destinationScreen = json.decode(url)["destination_screen"];
          if (MyApp.navigatorKey.currentState?.overlay == null) {
            SharedPreferencesStorage().setNotificationDestination(
              destination: destinationScreen,
            );
          } else {
            if (destinationScreen.isNotEmpty) {
              _navigateToNewScreen(destinationScreen);
            }
          }
        }
      }
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen((
      ReceivedNotification receivedNotification,
    ) {
      if (kDebugMode) {
        print(
            'Got a message whilst in the _configureDidReceiveLocalNotificationSubject!');
        print('Message data: ${receivedNotification.payload}');
      }

      int? id = int.tryParse(receivedNotification.payload ?? '');
      if (id != null) {
        //todo
      } else {
        String url = receivedNotification.payload.toString();
        if (url.startsWith('http') &&
            MyApp.navigatorKey.currentState?.context != null) {
          //todo
        }
      }
    });
  }

  _handleOpenRemoteNotificationWhenTerminated() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage?.data != null &&
        initialMessage?.data["destination_screen"] != null &&
        initialMessage?.data["destination_screen"].isNotEmpty) {
      SharedPreferencesStorage().setNotificationDestination(
        destination: initialMessage?.data["destination_screen"],
      );
    }
  }

  _handleOpenRemoteNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (!(message.data["destination_screen"]?.isEmpty ?? true)) {
        String destinationScreen = message.data["destination_screen"];
        _navigateToNewScreen(destinationScreen);
      }
    });
  }

  _navigateToNewScreen(String destinationScreen) {
    BuildContext? context = MyApp.navigatorKey.currentState?.overlay?.context;
    if (context == null) {
      return;
    }
    if (destinationScreen == 'chats') {
      //nav to chat
    } else if (destinationScreen == 'call') {
      //nav to call
    } else if (destinationScreen == 'news') {
      //nav to news
    } else if (destinationScreen == 'transcript') {
      //nav to transcript
    }
  }

  _handleFirebaseMessagingOnMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
        }

        if (Platform.isAndroid) {
          RemoteNotification? notification = message.notification;
          AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  importance: Importance.max,
                  priority: Priority.high,
                  showWhen: false);
          String? title = notification?.titleLocKey;
          // AppLocalizations.of(MyApp.navigatorKey.currentState?.context)
          //     ?.translate(notification?.titleLocKey);
          title = isNotNullOrEmpty(title) ? title : notification?.title;
          String? body = notification?.bodyLocKey;
          // AppLocalizations.of(MyApp.navigatorKey.currentState?.context)
          //     ?.translate(notification?.bodyLocKey);
          body = body ?? notification?.body;
          if (body != null && isNotNullOrEmpty(notification?.bodyLocArgs)) {
            body = body.replaceFirst(
              r'$bodyArg',
              notification?.bodyLocArgs.first ?? '',
            );
          }
          NotificationDetails platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics,
          );
          if (kDebugMode) {
            print('json.encode(message.data): ${json.encode(message.data)}');
          }
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            title,
            body,
            platformChannelSpecifics,
            payload: json.encode(message.data),
          );
        }
      }
    });
  }
}
