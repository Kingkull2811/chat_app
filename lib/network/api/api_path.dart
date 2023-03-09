class ApiPath{
  static const String apiDomain = 'http://localhost:8080';

  //static const String signup = '$apiDomain/api/auth/sign-up';
  static const String signup = 'http://localhost:8080/api/auth/sign-in';

  static const String login = '$apiDomain/api/auth/sign-in';

  static const String changePassword = '$apiDomain/api/auth/change-password';

  static const String forgotPassword = '$apiDomain/api/auth/forgot-password';

  static const String newPassword = '$apiDomain/api/auth/new-password';

  static const String refreshToken = '$apiDomain/api/auth/refresh-token';

  static const String sendOtp = '$apiDomain/api/auth/sign-in';




}