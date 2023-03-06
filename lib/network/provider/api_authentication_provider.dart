import 'package:chat_app/network/provider/login_provider.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utilities/secure_storage.dart';

class ApiAuthenticationProvider with ProviderMixin {
  final _loginProvider = LoginProvider();

  Future<bool> checkAuthenticationStatus() async {
    final preferences = await SharedPreferences.getInstance();
    final SecureStorage secureStorage = SecureStorage();
    String token = await secureStorage.readSecureData(AppConstants.accessTokenKey);
    try {
      // Access token
      String authTokenExpire =
          preferences.getString(AppConstants.authTokenExpireKey) ?? '';
      if (DateTime.parse(authTokenExpire).isBefore(DateTime.now())) {
        /// Refresh token
        String passwordExpireTimeKey =
            preferences.getString(AppConstants.passwordExpireTimeKey) ?? '';
        if (DateTime.parse(passwordExpireTimeKey).isAfter(DateTime.now())) {
          String refreshToken = await SecureStorage()
              .readSecureData(AppConstants.refreshTokenKey);
          // AzureTokenInfo? tokenInfo =
          // await _loginProvider.getAADTokenByRefreshToken(
          //   refreshToken: refreshToken,
          // );
          // await saveAADTokenInfo(tokenInfo: tokenInfo);
          return true;
        }
        return false;
      }
      return true;
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, Api);
    }

    return false;
  }

  Future<void> saveTokenInfo({
    required String token,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final SecureStorage secureStorage = SecureStorage();
    String tokenAfterSplit = token.split(' ')[1];
    await secureStorage.writeSecureData(AppConstants.accessTokenKey, tokenAfterSplit);
  }
}
