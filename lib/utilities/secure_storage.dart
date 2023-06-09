import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  ///---------get, set access-refresh token----------

  Future<void> setAccessToken({required String accessToken}) async =>
      await writeSecureData(AppConstants.accessTokenKey, accessToken);

  Future<String> getAccessToken() async =>
      await readSecureData(AppConstants.accessTokenKey);

  Future<void> setRefreshToken({required String refreshT}) async =>
      await writeSecureData(AppConstants.refreshTokenKey, refreshT);

  Future<String> getRefreshToken() async =>
      await readSecureData(AppConstants.refreshTokenKey) ?? '';

  /// write, read, delete data

  Future writeSecureData(String key, String? value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  Future readSecureData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }
}
