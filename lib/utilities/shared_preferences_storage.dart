import 'package:chat_app/network/response/user_info_response.dart';
import 'package:chat_app/utilities/secure_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/response/token_data_response.dart';
import 'app_constants.dart';

class SharedPreferencesStorage {
  static late SharedPreferences _prefs;
  final SecureStorage _secureStorage = SecureStorage();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setFirstTimeOpen(bool value) async {
    return await _prefs.setBool(AppConstants.firstTimeOpenKey, value);
  }

  bool getFirstTimeOpen() =>
      _prefs.getBool(AppConstants.firstTimeOpenKey) ?? true;

  Future<bool> setRememberInfo(bool value) async {
    return await _prefs.setBool(AppConstants.rememberInfo, value);
  }

  bool getRememberInfo() => _prefs.getBool(AppConstants.rememberInfo) ?? false;

  Future<bool> setLoggedOutStatus(bool value) async {
    return await _prefs.setBool(AppConstants.isLoggedOut, value);
  }

  bool getLoggedOutStatus() {
    return _prefs.getBool(AppConstants.isLoggedOut) ?? true;
  }

  Future<bool> setAgreeTerm(bool value) async {
    return await _prefs.setBool(AppConstants.agreedWithTermsKey, value);
  }

  bool getAgreedWithTerms() {
    return _prefs.getBool(AppConstants.agreedWithTermsKey) ?? false;
  }

  bool getFillProfileStatus() {
    return _prefs.getBool(AppConstants.isFillProfileKey) ?? false;
  }

  ///save user info
  Future<void> setSaveUserInfo(UserInfoResponse? signInData) async {
    if (signInData != null) {
      await _secureStorage.writeSecureData(
          AppConstants.accessTokenKey, signInData.accessToken);
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

      await _prefs.setStringList(
          AppConstants.rolesKey, signInData.roles ?? ['ROLE_USER']);

      await checkRoles(signInData.roles ?? ['ROLE_USER']);
    }
  }

  Future<void> saveInfoWhenRefreshToken(
      {required TokenDataResponse? refreshTokenData}) async {
    await _secureStorage.writeSecureData(
        AppConstants.accessTokenKey, refreshTokenData?.accessToken);
    await _secureStorage.writeSecureData(
        AppConstants.refreshTokenKey, refreshTokenData?.refreshToken);
    await _prefs.setString(AppConstants.accessTokenExpiredKey,
        refreshTokenData?.expiredAccessToken ?? '');
  }

  Future<void> checkRoles(List<String> listRoles) async {
    if (isNotNullOrEmpty(listRoles)) {
      if (listRoles.contains('ROLE_ADMIN')) {
        await _prefs.setBool(AppConstants.isAdminRoleKey, true);
        await _prefs.setBool(AppConstants.isTeacherRoleKey, false);
      } else if (listRoles.contains('ROLE_TEACHER')) {
        await _prefs.setBool(AppConstants.isAdminRoleKey, false);
        await _prefs.setBool(AppConstants.isTeacherRoleKey, true);
      } else {
        await _prefs.setBool(AppConstants.isAdminRoleKey, false);
        await _prefs.setBool(AppConstants.isTeacherRoleKey, false);
      }
    } else {
      await _prefs.setBool(AppConstants.isAdminRoleKey, false);
      await _prefs.setBool(AppConstants.isTeacherRoleKey, false);
    }
  }

  bool getAdminRole() => _prefs.getBool(AppConstants.isAdminRoleKey) ?? false;

  bool getTeacherRole() =>
      _prefs.getBool(AppConstants.isTeacherRoleKey) ?? false;

  bool getUserRole() => !getAdminRole() && !getTeacherRole();

  Future<void> setImageAvartarUrl(String imageUrl) async {
    await _prefs.setString(AppConstants.imageAvartarUrlKey, imageUrl);
  }

  String getImageAvartarUrl() =>
      _prefs.getString(AppConstants.imageAvartarUrlKey) ?? '';

  int getUserId() {
    final String userID = _prefs.getString(AppConstants.userIdKey) ?? '';
    if (isNullOrEmpty(userID)) {
      return 0;
    }
    return int.parse(userID);
  }

  Future<String> getUserEmail() async =>
      await _secureStorage.readSecureData(AppConstants.emailKey) ?? '';

  Future<void> setFullName(String fullName) async =>
      await _prefs.setString(AppConstants.fullNameKey, fullName);

  String getUserName() => _prefs.getString(AppConstants.usernameKey) ?? '';

  String getFullName() => _prefs.getString(AppConstants.fullNameKey) ?? '';

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
    // _prefs.remove(AppConstants.accessTokenExpiredKey);
    // _prefs.remove(AppConstants.refreshTokenExpiredKey);
    // _prefs.remove(AppConstants.usernameKey);
    _prefs.remove(AppConstants.userIdKey);
    _prefs.setBool(AppConstants.isLoggedOut, true);
    _prefs.setBool(AppConstants.isFillProfileKey, false);

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
