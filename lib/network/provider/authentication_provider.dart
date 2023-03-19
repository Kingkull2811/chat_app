import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/login_provider.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../utilities/secure_storage.dart';

class AuthenticationProvider with ProviderMixin {
  final _loginProvider = LoginProvider();

  Future<bool> checkAuthenticationStatus() async {
    final SecureStorage secureStorage = SecureStorage();
    String token =
        await secureStorage.readSecureData(AppConstants.accessTokenKey);
    try {
      DateTime expirationDate = JwtDecoder.getExpirationDate(token);

      if (expirationDate.isBefore(DateTime.now())) {
        String refreshToken =
            await secureStorage.readSecureData(AppConstants.refreshTokenKey);
        final response = await _loginProvider.getTokenByRefreshToken(
          refreshToken: refreshToken,
        );
        if (response.accessToken != null && response.accessToken != null) {
          await saveTokenInfo(
            newToken: response.accessToken!,
            refreshToken: response.refreshToken!,
          );
        } else {
          return false;
        }
      }
      return true;
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.login);
    }
    return false;
  }

  Future<void> saveTokenInfo({
    required String newToken,
    required String refreshToken,
  }) async {
    final SecureStorage secureStorage = SecureStorage();
    String tokenAfterSplit = newToken.split(' ')[1];

    await secureStorage.writeSecureData(
      AppConstants.accessTokenKey,
      tokenAfterSplit,
    );
    await secureStorage.writeSecureData(
      AppConstants.refreshTokenKey,
      refreshToken,
    );
  }


}
