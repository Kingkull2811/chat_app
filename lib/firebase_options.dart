// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDGD4HfInR7ybpXD7sYguYP-5j-U2vDQ80',
    appId: '1:103251286025:web:03d480e7b5bdae42f840d8',
    messagingSenderId: '103251286025',
    projectId: 'chatapp-97dbc',
    authDomain: 'chatapp-97dbc.firebaseapp.com',
    storageBucket: 'chatapp-97dbc.appspot.com',
    measurementId: 'G-471HG0X2MQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYIXozmdWTfSFb1kZSyvn6rCi_CIablz0',
    appId: '1:103251286025:android:a85cdc90c8e4298af840d8',
    messagingSenderId: '103251286025',
    projectId: 'chatapp-97dbc',
    storageBucket: 'chatapp-97dbc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCe1GkLWUCfTJ1Xhg9nNZlOBu5XwK9AXrE',
    appId: '1:103251286025:ios:38aa7d54e4ae9a7ef840d8',
    messagingSenderId: '103251286025',
    projectId: 'chatapp-97dbc',
    storageBucket: 'chatapp-97dbc.appspot.com',
    androidClientId: '103251286025-qgj685ko98cko0u85uq5rc8v0tfofhb6.apps.googleusercontent.com',
    iosClientId: '103251286025-qlao04f4jmisgvnaf58qohrbmokipeqq.apps.googleusercontent.com',
    iosBundleId: 'com.kull.chatApp',
  );
}
