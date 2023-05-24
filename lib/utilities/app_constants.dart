import 'package:dio/dio.dart';

class AppConstants {
  ///for flutter web
  static const apiKey = 'AIzaSyDGD4HfInR7ybpXD7sYguYP-5j-U2vDQ80';
  static const appId = '1:103251286025:web:03d480e7b5bdae42f840d8';
  static const messagingSenderId = '103251286025';
  static const projectId = 'chatapp-97dbc';

  ///agora SDK config
  static const agoraAppID = '4b2ba68b5c5b4645a156f8626af8d936';
  static const agoraAppCertificate = '6fbf7e2b64634605be0a11c9263667e5';
  static const agoraToken =
      '007eJxTYGC1kxbkabDg2d9+eYPWm7Y61ZrIGkXvS8GZxdv4Kjb/K1ZgMEkySko0s0gyTTZNMjEzMU00NDVLszAzMktMs0ixNDYTEs5NaQhkZFhpOoeJkQECQXxehuzSnJz45IzEkvjEggIGBgBpeB+/';

  static RegExp emailExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]');
  static RegExp passwordExp =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

  static const int maxConnectionPerHost = 16;

  static const String rememberInfo = 'REMEMBER_INFO';
  static const String isLoggedOut = 'IS_LOGGED_OUT';
  static const String refreshTokenKey = 'REFRESH_TOKEN';
  static const String refreshTokenExpiredKey = 'REFRESH_TOKEN_EXPIRED';
  static const String accessTokenKey = 'ACCESS_TOKEN';
  static const String accessTokenExpiredKey = 'ACCESS_TOKEN_EXPIRED';
  static const String usernameKey = 'USERNAME';
  static const String userPhoneKey = 'PHONE';
  static const String fullNameKey = 'FULL_NAME';
  static const String emailKey = 'EMAIL';
  static const String userIdKey = 'USER_ID';
  static const String isAdminRoleKey = 'IS_ADMIN_ROLE';
  static const String isTeacherRoleKey = 'IS_TEACHER_ROLE';
  static const String rolesKey = 'ROLES';
  static const String imageAvartarUrlKey = 'IMAGE_AVARTAR_URL_KEY';

  static const String isFillProfileKey = 'IS_FILL_PROFILE_STATUS';

  static const String nightMode = 'IS_NIGHT_MODE';
  static const String soundModeKey = 'IS_TURN_ON_SOUND';
  static const String previewModeKey = 'IS_TURN_ON_PREVIEW_NOTIFICATION';
  static const String vibrateModeKey = 'IS_TURN_ON_VIBRATE_CALL_COMING';

  static const String firstTimeOpenKey = 'FIRST_TIME_OPEN';
  static const String agreedWithTermsKey = 'AGREED_WITH_TERMS';

  //for set options timeOut waiting request dio connect to servers
  static Options options = Options(
    sendTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
    receiveDataWhenStatusError: true,
  );

  static const double defaultLoadingNetworkImageSize = 25;

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

  static const String calculateFinalPoint = 'How to calculate final point?';
  static const String finalPoint =
      'final_point = 0.6 x final_exam_point + 0.4 x process_point';
  static const String processPoint =
      'process_point = (first_point + second_point)/2';

  static const List<String> listSemesterYear = [
    'semester 1 2021-2022',
    'semester 2 2021-2022',
    'semester 1 2022-2023',
    'semester 2 2022-2023',
    'semester 1 2023-2024',
    'semester 2 2023-2024',
    'semester 1 2024-2025',
    'semester 2 2024-2025',
    'semester 1 2025-2026',
    'semester 2 2025-2026',
  ];
  static const List<String> listSchoolYear = [
    '2021-2022',
    '2022-2023',
    '2023-2024',
    '2024-2025',
    '2025-2026',
  ];

  ///collection in firebase & child folder storage
  static const String userCollection = 'users';
  static const String messageCollection = 'messages';
  static const String chatsCollection = 'chats';
  static const String messageListCollection = 'message_list';
  static const String callCollection = 'calls';

  static const String imageChild = 'images';
  static const String imageMessageChild = 'messages';
  static const String imageNewsChild = 'news';
  static const String imageStudentsChild = 'students';
  static const String imageProfilesChild = 'profiles';
}
