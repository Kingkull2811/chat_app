class ApiPath{
  static const String apiDomain = 'http://192.168.1.26:8080';
  static const String apiDomainMac = 'http://10.10.142.45:8080';

  static const String signup = '$apiDomainMac/api/auth/sign-up';

  static const String login = '$apiDomainMac/api/auth/sign-in';

  static const String changePassword = '$apiDomainMac/api/auth/change-password';

  static const String forgotPassword = '$apiDomainMac/api/auth/forgot-password';

  static const String newPassword = '$apiDomainMac/api/auth/new-password';

  static const String refreshToken = '$apiDomainMac/api/auth/refresh-token';

  static const String sendOtp = '$apiDomainMac/api/auth/send-otp';




}