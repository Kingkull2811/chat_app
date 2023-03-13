import 'package:chat_app/network/model/forgot_password_result.dart';
import 'package:chat_app/network/provider/forgot_password_provider.dart';
import 'package:chat_app/network/response/forgot_password_response.dart';


class ForgotPasswordRepository {
  final  _forgotPasswordProvider = ForgotPasswordProvider();
  Future<ForgotPasswordResult> forgotPassword({
    required String email,
  }) async {
    ForgotPasswordResponse? forgotPasswordResponse =
        await _forgotPasswordProvider.fogotPassword(email: email);

    if (forgotPasswordResponse.httpStatus == 200) {
      return ForgotPasswordResult(isSuccess: true);
    }
    return ForgotPasswordResult(errors: forgotPasswordResponse.errors);
  }
}
