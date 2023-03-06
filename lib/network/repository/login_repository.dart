import 'package:chat_app/network/provider/login_provider.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';

import '../model/login_result.dart';
import '../response/login_response.dart';

class LoginRepository {
  final LoginProvider _loginProvider = LoginProvider();

  Future<void> _saveUserInfo( )async{
    await SharedPreferencesStorage().setSaveUserInfo();
}

  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    LoginResponse loginResponse = await _loginProvider.login(
      username : username,
      password: password,
    );
    if(loginResponse.status == 200){
      _saveUserInfo(loginResponse.);
    }

    return LoginResult();
  }
}
