import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/forgot_password_response.dart';
import 'package:chat_app/utilities/app_constants.dart';

class ForgotPasswordProvider with ProviderMixin {
  Future<ForgotPasswordResponse> forgotPassword({
    required String? email,
  }) async {
    try {
      final response = await dio.post(
        ApiPath.forgotPassword,
        data: {"email": email},
        options: AppConstants.options,
      );
      return ForgotPasswordResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.forgotPassword);
      return ForgotPasswordResponse();
    }

  }
}
