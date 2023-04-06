import 'dart:developer';
import 'dart:io';

import 'package:chat_app/network/model/base_auth_result.dart';
import 'package:chat_app/network/provider/auth_provider.dart';
import 'package:chat_app/network/response/login_response.dart';
import 'package:chat_app/network/response/user_info_response.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/cupertino.dart';

class AuthRepository {
  final _authProvider = AuthProvider();

  Future<void> _saveUserDataToFirebase({
    required BuildContext context,
    // required ProviderRef ref,
    required int? id,
    required String? username,
    required String? email,
    required String? phoneNumber,
    required String? roles,
    required File? imageAvt,
  }) async {}

  Future<void> _saveUserInfo(UserInfoResponse? userInfoData) async {
    await SharedPreferencesStorage().setSaveUserInfo(userInfoData);
  }

  Future<BaseAuthResult> refreshToken({
    required String refreshToken,
  }) async {
    final response =
        await _authProvider.refreshToken(refreshToken: refreshToken);

    log('login response: ${response.toString()}');

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
    log('login response: ${loginResponse.toString()}');

    if (loginResponse.httpStatus == 200) {
      _saveUserInfo(loginResponse.data);

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
  }) async {
    final signUpResponse = await _authProvider.signUp(
      username: username,
      email: email,
      password: password,
    );
    log("sign_up response: ${signUpResponse.toString()}");
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

  Future<BaseAuthResult> forgotPassword({
    required String email,
  }) async {
    final response = await _authProvider.forgotPassword(email: email);

    log('forgot response: ${response.toString()})');
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

    log('verify response ${response.toString()}');
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
