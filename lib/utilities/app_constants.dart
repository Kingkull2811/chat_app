import 'dart:ui';

import 'package:dio/dio.dart';

class AppConstants {
  ///for flutter web
  static const apiKey = 'AIzaSyDGD4HfInR7ybpXD7sYguYP-5j-U2vDQ80';
  static const appId = '1:103251286025:web:03d480e7b5bdae42f840d8';
  static const messagingSenderId = '103251286025';
  static const projectId = 'chatapp-97dbc';


  final greyLight = const Color(0xFF7b7b7b);
  final grey630 = const Color(0xFF737373);
  final grey130 = const Color(0xFFCFD8DC);
  final red700 = const Color(0xFFCA0000);
  final green600 = const Color(0xFF2AD000);

  static RegExp emailExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  static RegExp passwordExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

  static const int maxConnectionPerHost = 16;

  static const String rememberInfo = 'REMEMBER_INFO';
  static const String isLoggedOut = 'IS_LOGGED_OUT';
  static const String refreshTokenKey = 'REFRESH_TOKEN';
  static const String refreshTokenExpiredKey = 'REFRESH_TOKEN_EXPIRED';
  static const String accessTokenKey = 'ACCESS_TOKEN';
  static const String accessTokenExpiredKey = 'ACCESS_TOKEN_EXPIRED';
  static const String usernameKey = 'USERNAME';
  static const String emailKey = 'EMAIL';

  static const String nightMode = 'IS_NIGHT_MODE';

  static const String firstTimeOpenKey = 'FIRST_TIME_OPEN';
  static const String agreedWithTermsKey = 'AGREED_WITH_TERMS';

  //for set options timeOut waiting request dio connect to servers
  static Options options = Options(
    sendTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
    receiveDataWhenStatusError: true,
  );

  static const String noInternetTitle = 'No Internet Connection';
  static const String noInternetContent =
      'Please check your internet connection again or connect to Wi-fi';

  static const String emailNotMatch = 'Please enter a valid email address.';
  static const String passwordNotMatch =
      'Password must contain at least 6 characters, including one uppercase letter, one lowercase letter, and one number.';
  static const String emailPasswordNotMatch =
      'Please enter a valid email address.\nPassword must contain at least 6 characters, including one uppercase letter, one lowercase letter, and one number.';
  static const String passwordNotValid =
      'Password must has Minimum 1 Upper case, Minimum 1 lowercase, Minimum 1 Numeric Number, Minimum 1 Special Character, Common Allow Character ( ! @ # \$ & * ~ )';

  static const String longText =
      'What is Lorem Ipsum? \nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\nWhy do we use it?\nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose '
      '(injected humour and the like).\nWhere does it come from? Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.';
}
