import 'package:chat_app/network/model/base_auth_result.dart';
import 'package:chat_app/network/provider/auth_provider.dart';
import 'package:chat_app/network/response/base_response.dart';
import 'package:chat_app/network/response/login_response.dart';

class AuthRepository {
  final _authProvider = AuthProvider();

  Future<BaseAuthResult> refreshToken({
    required String refreshToken,
  }) async {
    final response =
        await _authProvider.refreshToken(refreshToken: refreshToken);

    // log('login response: ${response.toString()}');

    if (response.httpStatus == 200) {
      //_saveUserInfo(response.data);
      return BaseAuthResult(
        isSuccess: true,
        message: response.message,
        errors: null,
      );
    }
    return BaseAuthResult(
      isSuccess: false,
      message: null,
      errors: response.errors,
    );
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async =>
      await _authProvider.login(username: username, password: password);

  Future<BaseResponse> signUp({required Map<String, dynamic> data}) async =>
      await _authProvider.signUp(data: data);

  Future<Object> getUserInfo({required int userId}) async =>
      await _authProvider.getUserInfo(userId: userId);

  Future<Object> fillProfile({
    required int userID,
    required Map<String, dynamic> data,
  }) async =>
      await _authProvider.fillProfile(userID: userID, data: data);

  Future<Object> changePassword({
    required String oldPass,
    required String newPass,
    required String confPass,
  }) async {
    final data = {
      "confirm_password": confPass,
      "current_password": oldPass,
      "password": newPass
    };
    return _authProvider.changePassword(data);
  }

  Future<BaseResponse> forgotPassword({
    required String email,
  }) async {
    return await _authProvider.forgotPassword(email: email);
  }

  Future<BaseResponse> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    return await _authProvider.verifyOtp(email: email, otpCode: otpCode);
  }

  Future<BaseResponse> newPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await _authProvider.newPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
