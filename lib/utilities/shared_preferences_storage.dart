import 'package:chat_app/network/response/user_info_response.dart';
import 'package:chat_app/utilities/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';

class SharedPreferencesStorage {
  static late SharedPreferences _prefs;
  final SecureStorage _secureStorage = SecureStorage();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setLoggedOutStatus(bool value) async {
    return await _prefs.setBool(AppConstants.isLoggedOut, value);
  }

  bool? getLoggedOutStatus() {
    return _prefs.getBool(AppConstants.isLoggedOut);
  }

  bool? getAgreedWithTerms() {
    return _prefs.getBool(AppConstants.agreedWithTermsKey);
  }

  bool getFillProfileStatus() {
    return _prefs.getBool(AppConstants.isFillProfileKey) ?? false;
  }

  ///save user info
  Future<void> setSaveUserInfo(UserInfoResponse? signInData) async {
    if (signInData != null) {
      var token = signInData.accessToken?.split(' ')[1];
      await _secureStorage.writeSecureData(AppConstants.accessTokenKey, token);
      await _secureStorage.writeSecureData(
          AppConstants.refreshTokenKey, signInData.refreshToken);
      await _secureStorage.writeSecureData(
          AppConstants.emailKey, signInData.email.toString());

      await _prefs.setString(AppConstants.accessTokenExpiredKey,
          signInData.expiredAccessToken ?? '');
      await _prefs.setString(AppConstants.refreshTokenExpiredKey,
          signInData.expiredRefreshToken ?? '');
      await _prefs.setString(
          AppConstants.usernameKey, signInData.username ?? '');
      await _prefs.setString(AppConstants.userIdKey, signInData.id.toString());

      await _prefs.setString(AppConstants.userRoleKey, signInData.roles ?? '');

      //get isFillProfile in signData to save
      await _prefs.setBool(AppConstants.isFillProfileKey, false);
    }
  }

  String getUserRole() {
    return _prefs.getString(AppConstants.userRoleKey) ?? '';
  }

  Future<String> getAccessToken() async {
    final token = await _secureStorage.readSecureData(
      AppConstants.accessTokenKey,
    );
    return token;
  }

  String getAccessTokenExpired() {
    return _prefs.getString(AppConstants.accessTokenExpiredKey) ?? '';
  }

  String getRefreshTokenExpired() {
    return _prefs.getString(AppConstants.refreshTokenExpiredKey) ?? '';
  }

  void resetDataWhenLogout() {
    _prefs.remove(AppConstants.accessTokenExpiredKey);
    _prefs.remove(AppConstants.refreshTokenExpiredKey);
    _prefs.remove(AppConstants.usernameKey);
    _prefs.setBool(AppConstants.isLoggedOut, false);
    _prefs.setBool(AppConstants.rememberInfo, false);

    _secureStorage.deleteSecureData(AppConstants.emailKey);
    _secureStorage.deleteSecureData(AppConstants.accessTokenKey);
    _secureStorage.deleteSecureData(AppConstants.refreshTokenKey);
  }

  /// ---setting---

  Future<bool> setNightMode(bool isNightMode) {
    return _prefs.setBool(AppConstants.nightMode, isNightMode);
  }

  bool? getNightMode() {
    return _prefs.getBool(AppConstants.nightMode);
  }

  Future<bool> setSoundMode(bool value) {
    return _prefs.setBool(AppConstants.soundModeKey, value);
  }

  bool? getSoundMode() {
    return _prefs.getBool(AppConstants.soundModeKey);
  }

  Future<bool> setPreviewNotification(bool value) {
    return _prefs.setBool(AppConstants.previewModeKey, value);
  }

  bool? getPreviewNotification() {
    return _prefs.getBool(AppConstants.previewModeKey);
  }

  Future<bool> setVibrateMode(bool value) {
    return _prefs.setBool(AppConstants.vibrateModeKey, value);
  }

  bool? getVibrateMode() {
    return _prefs.getBool(AppConstants.vibrateModeKey);
  }

  ///
}
