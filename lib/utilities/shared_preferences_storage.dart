import 'package:chat_app/network/response/user_info_response.dart';
import 'package:chat_app/utilities/secure_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/model/refresh_token_model.dart';
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

  bool getAgreedWithTerms() =>
      _prefs.getBool(AppConstants.agreedWithTermsKey) ?? false;

  ///-----------------SET USER INFO--------------------

  Future<void> setFullName(String fullName) async =>
      await _prefs.setString(AppConstants.fullNameKey, fullName);

  Future<void> setSaveUserInfo(UserInfoResponse? signInData) async {
    if (signInData != null) {
      await _secureStorage.setAccessToken(accessToken: signInData.accessToken);
      await _secureStorage.setRefreshToken(refreshT: signInData.refreshToken);

      await _prefs.setString(
        AppConstants.accessTokenExpiredKey,
        signInData.expiredAccessToken,
        // '2023-06-08T18:24:00.000',
      );
      await _prefs.setString(
        AppConstants.refreshTokenExpiredKey,
        signInData.expiredRefreshToken,
        // '2023-06-08T18:25:00.000',
      );

      await _prefs.setString(AppConstants.usernameKey, signInData.username);
      await _prefs.setString(AppConstants.userIdKey, signInData.id.toString());
      await _prefs.setString(AppConstants.emailKey, signInData.email);

      await _prefs.setStringList(
          AppConstants.rolesKey, signInData.roles ?? ['ROLE_USER']);

      await checkRoles(signInData.roles ?? ['ROLE_USER']);
    }
  }

  Future<void> saveInfoWhenRefreshToken({
    required RefreshTokenModel? data,
  }) async {
    if (data != null) {
      if (data.accessToken != null) {
        await _secureStorage.setAccessToken(accessToken: data.accessToken!);
      }
      if (data.refreshToken != null) {
        await _secureStorage.setRefreshToken(refreshT: data.refreshToken!);
      }
      if (data.expiredAccessToken != null) {
        await _prefs.setString(
          AppConstants.accessTokenExpiredKey,
          data.expiredAccessToken!,
          // '2023-06-08T18:26:00.000',
        );
      }
    }
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

  ///-----------------GET USER INFO--------------------

  String getUserName() => _prefs.getString(AppConstants.usernameKey) ?? '';

  String getFullName() => _prefs.getString(AppConstants.fullNameKey) ?? '';

  String getUserEmail() => _prefs.getString(AppConstants.emailKey) ?? '';

  String getImageAvatarUrl() =>
      _prefs.getString(AppConstants.imageAvatarUrlKey) ?? '';

  bool getFillProfileStatus() {
    return _prefs.getBool(AppConstants.isFillProfileKey) ?? false;
  }

  bool getAdminRole() => _prefs.getBool(AppConstants.isAdminRoleKey) ?? false;

  bool getTeacherRole() =>
      _prefs.getBool(AppConstants.isTeacherRoleKey) ?? false;

  bool getUserRole() => !getAdminRole() && !getTeacherRole();

  Future<void> setImageAvatarUrl(String imageUrl) async {
    await _prefs.setString(AppConstants.imageAvatarUrlKey, imageUrl);
  }

  int getUserId() {
    final String userID = _prefs.getString(AppConstants.userIdKey) ?? '';
    if (isNullOrEmpty(userID)) {
      return 0;
    }
    return int.parse(userID);
  }

  String getAccessTokenExpired() {
    return _prefs.getString(AppConstants.accessTokenExpiredKey) ?? '';
  }

  String? getAccessToken() => _prefs.getString(AppConstants.accessTokenKey);

  String? getRefreshToken() => _prefs.getString(AppConstants.refreshTokenKey);

  String getRefreshTokenExpired() {
    return _prefs.getString(AppConstants.refreshTokenExpiredKey) ?? '';
  }

  void resetDataWhenLogout() {
    _prefs.setBool(AppConstants.isLoggedOut, true);
    _prefs.setBool(AppConstants.isFillProfileKey, false);
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
}
