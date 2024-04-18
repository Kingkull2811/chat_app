class AppConstants {

  static RegExp emailExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]');
  static RegExp passwordExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

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
  static const String imageAvatarUrlKey = 'IMAGE_AVATAR_URL_KEY';

  static const String isFillProfileKey = 'IS_FILL_PROFILE_STATUS';

  static const String nightMode = 'IS_NIGHT_MODE';
  static const String soundModeKey = 'IS_TURN_ON_SOUND';
  static const String previewModeKey = 'IS_TURN_ON_PREVIEW_NOTIFICATION';
  static const String vibrateModeKey = 'IS_TURN_ON_VIBRATE_CALL_COMING';

  static const String firstTimeOpenKey = 'FIRST_TIME_OPEN';
  static const String agreedWithTermsKey = 'AGREED_WITH_TERMS';

  static const double defaultLoadingNetworkImageSize = 25;

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

  ///app name
  static const String appName= "App Name";
}
