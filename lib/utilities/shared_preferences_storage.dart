import 'package:chat_app/utilities/secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/response/login_response.dart';
import 'app_constants.dart';

class SharedPreferencesStorage {
  static late SharedPreferences _prefs;

  static Future<void> inti() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setSaveUserInfo(LoginData? loginData) async {
    if (loginData != null) {
      var token = loginData.accessToken?.split(' ')[1];
      final SecureStorage secureStorage = SecureStorage();

      //write accessToken, refreshToken to secureStorage
      await secureStorage.writeSecureData(AppConstants.accessTokenKey, token);
      await secureStorage.writeSecureData(
          AppConstants.refreshTokenKey, loginData.refreshToken);
      await _prefs.setString(AppConstants.emailKey, loginData.email.toString());
      await _prefs.setString(
          AppConstants.usernameKey, loginData.username.toString());

      //Decode token and get expiration time
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        bool hasExpired = JwtDecoder.isExpired(token);
        DateTime expirationDate = JwtDecoder.getExpirationDate(token);
      }
    }
  }

  void resetDataWhenLogout() {
    // _prefs?.remove(AppConstants.onlyUsingWifiToDownloadKey);
    // _prefs?.remove(AppConstants.usingOnlineModeKey);
    _prefs.setBool(AppConstants.isLoggedOut, true);
  }

  String getPasswordExpireTime() {
    return _prefs.getString(AppConstants.passwordExpireTimeKey) ?? '';
  }

  Future<bool> setNightMode(bool isNightMode){
    return _prefs.setBool(AppConstants.nightMode, isNightMode);
  }
  bool? getNightMode(){
    return _prefs.getBool(AppConstants.nightMode);
  }
}
