import '../provider/sign_up_provider.dart';
import '../response/base_response.dart';

class SignUpRepository {
  late SignUpProvider _signUpProvider;

  Future<BaseResponse> signUp({
    required String username,
    required String email,
    required String password,
  }) =>
      _signUpProvider.signUp(
        username: username,
        email: email,
        password: password,
      );

}
