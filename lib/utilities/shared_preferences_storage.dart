import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage {
  static SharedPreferences? _prefs;

  static Future<void> inti() async{
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setSaveUserInfo()async{

  }
}