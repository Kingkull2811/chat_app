import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';

class SharedPreferencesStorage {
  static SharedPreferences? _prefs;

  static Future<void> inti() async{
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setSaveUserInfo()async{

  }

  void resetDataWhenLogout() {
    // _prefs?.remove(AppConstants.onlyUsingWifiToDownloadKey);
    // _prefs?.remove(AppConstants.usingOnlineModeKey);
    _prefs?.setBool(AppConstants.isLoggedOut, true);
  }

  String getPasswordExpireTime() {
    return _prefs?.getString(AppConstants.passwordExpireTimeKey) ?? '';
  }
}