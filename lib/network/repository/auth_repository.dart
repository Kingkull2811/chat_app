import 'dart:developer';

import 'package:chat_app/network/model/base_auth_result.dart';
import 'package:chat_app/network/provider/auth_provider.dart';
import 'package:chat_app/network/response/login_response.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';

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

  Future<BaseAuthResult> login({
    required String username,
    required String password,
  }) async {
    LoginResponse loginResponse = await _authProvider.login(
      username: username,
      password: password,
    );
    // log('login response: ${loginResponse.toString()}');

    if (loginResponse.httpStatus == 200) {
      await SharedPreferencesStorage().setSaveUserInfo(loginResponse.data);

      return BaseAuthResult(
        isSuccess: true,
        message: loginResponse.message,
        errors: null,
      );
    }
    return BaseAuthResult(
      isSuccess: false,
      message: null,
      errors: loginResponse.errors,
    );
  }

  Future<BaseAuthResult> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required List<String> roles,
  }) async {
    final data = {
      "confirmPassword": confirmPassword,
      "email": email,
      "fullName": null,
      "isFillProfileKey": false,
      "password": password,
      "phone": null,
      "roles": [roles],
      "username": username
    };

    final signUpResponse = await _authProvider.signUp(data: data);
    // log("sign_up response: ${signUpResponse.toString()}");
    if (signUpResponse.httpStatus == 200) {
      return BaseAuthResult(
        isSuccess: true,
        message: signUpResponse.message,
        errors: null,
      );
    }
    return BaseAuthResult(
      isSuccess: false,
      message: null,
      errors: signUpResponse.errors,
    );
  }

  Future<Object> getUserInfo({required int userId}) async =>
      await _authProvider.getUserInfo(userId: userId);

  Future<Object> fillProfile({
    required int userID,
    required String fullName,
    required String phone,
    required String imageUrl,
  }) async {
    final data = {
      // "id": 1,
      // "username": "string",
      // "email": "string@gmail.com",
      // "roles": [
      //   {"id": 2, "name": "ROLE_USER"}
      // ],
      "fullName": fullName,
      "phone": phone,
      "isFillProfileKey": true,
      "fileUrl": imageUrl
    };

    return await _authProvider.fillProfile(userID: userID, data: data);
  }

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

  Future<BaseAuthResult> forgotPassword({
    required String email,
  }) async {
    final response = await _authProvider.forgotPassword(email: email);

    // log('forgot response: ${response.toString()})');
    if (response.httpStatus == 200) {
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

  Future<BaseAuthResult> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final response = await _authProvider.verifyOtp(
      email: email,
      otpCode: otpCode,
    );

    // log('verify response ${response.toString()}');
    if (response.httpStatus == 200) {
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

  Future<BaseAuthResult> newPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _authProvider.newPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    log('newPass response ${response.toString()}');
    if (response.httpStatus == 200) {
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
}
