import 'package:dio/dio.dart';

class AppConstants {
  ///for flutter web
  static const apiKey = 'AIzaSyDGD4HfInR7ybpXD7sYguYP-5j-U2vDQ80';
  static const appId = '1:103251286025:web:03d480e7b5bdae42f840d8';
  static const messagingSenderId = '103251286025';
  static const projectId = 'chatapp-97dbc';

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

  static const String longText =
      'What is Lorem Ipsum? \nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\nWhy do we use it?\nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose '
      '(injected humour and the like).\nWhere does it come from? Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.';

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

  static const String userCollection = 'users';
  static const String messageCollection = 'messages';
  static const String messageListCollection = 'message_list';
  static const String imageChild = 'images';
}
