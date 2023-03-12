import 'package:chat_app/network/response/forgot_password_response.dart';

import '../model/forgot_password_result.dart';
import '../provider/forgot_password_provider.dart';

class ForgotPasswordRepository {
  ForgotPasswordProvider? _forgotPasswordProvider;
  Future<ForgotPasswordResult> forgotPassword({
    required String email,
  }) async {
    ForgotPasswordResponse? forgotPasswordResponse =
        await _forgotPasswordProvider?.fogotPassword(email: email);

    if (forgotPasswordResponse?.httpStatus == 200) {
      return ForgotPasswordResult(isSuccess: true);
    }
    return ForgotPasswordResult(errors: forgotPasswordResponse?.errors?.errorMessage);
  }
}
