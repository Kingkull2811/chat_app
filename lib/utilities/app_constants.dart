import 'dart:ui';

class AppConstants {
  ///for flutter web
  static const apiKey = 'AIzaSyDGD4HfInR7ybpXD7sYguYP-5j-U2vDQ80';
  static const appId = '1:103251286025:web:03d480e7b5bdae42f840d8';
  static const messagingSenderId = '103251286025';
  static const projectId = 'chatapp-97dbc';

  final primaryColor = const Color(0xFFee7b64);
  final greyLight = const Color(0xFF7b7b7b);
  final grey630= const Color(0xFF737373);

  static const int maxConnectionPerHost = 16;

  static const String rememberInfo = 'REMEMBER_INFO';
  static const String isLoggedOut = 'IS_LOGGED_OUT';
  static const String passwordExpireTimeKey = 'PASSWORD_EXPIRE_TIME';

  static const String firstTimeOpenKey = 'FIRST_TIME_OPEN';
  static const String agreedWithTermsKey = 'AGREED_WITH_TERMS';


  static const String noInternetTitle = 'No Internet Connection';
  static const String noInternetContent = 'Please check your internet connection again or connect to Wi-fi';
}
