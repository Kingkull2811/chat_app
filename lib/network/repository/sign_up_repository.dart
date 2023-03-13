import 'dart:developer';

import 'package:chat_app/network/model/sign_up_result.dart';
import 'package:chat_app/network/provider/sign_up_provider.dart';
import 'package:chat_app/network/response/sign_up_response.dart';

class SignUpRepository {
  final _signUpProvider = SignUpProvider();

  Future<SignUpResult> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    SignUpResponse signUpResponse = await _signUpProvider.signUp(
      username: username,
      email: email,
      password: password,
    );
    log("response: $signUpResponse");
    if (signUpResponse.httpStatus == 200) {
      return SignUpResult(
        isSuccess: true,
        message: signUpResponse.message,
        errors: null,
      );
    }
    return SignUpResult(
      isSuccess: false,
      message: null,
      errors: signUpResponse.errors,
    );
  }
}
