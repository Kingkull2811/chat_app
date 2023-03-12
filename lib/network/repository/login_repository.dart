import 'package:chat_app/network/provider/login_provider.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';

import '../model/login_result.dart';
import '../response/login_response.dart';

class LoginRepository {
  final _loginProvider = LoginProvider();

  Future<void> _saveUserInfo(LoginData? loginData) async {
    await SharedPreferencesStorage().setSaveUserInfo(loginData);
  }

  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    LoginResponse loginResponse = await _loginProvider.login(
      username: username,
      password: password,
    );
    if (loginResponse.httpStatus == 200) {
      _saveUserInfo(loginResponse.data);
      return LoginResult(isSuccess: true);
    }

    return LoginResult();
  }
}
