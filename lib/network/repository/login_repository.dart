import 'package:chat_app/network/provider/login_provider.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';

import '../model/login_result.dart';

class LoginRepository {
  LoginProvider _loginProvider = LoginProvider();

  Future<void> _saveUserInfo()async{
    await SharedPreferencesStorage().setSaveUserInfo();
}

  Future<LoginResult> login({
    required String phone,
    required String password,
  }) async {

    return LoginResult();
  }
}
