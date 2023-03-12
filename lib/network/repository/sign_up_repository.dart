import '../provider/sign_up_provider.dart';
import '../response/sign_up_response.dart';

class SignUpRepository {
  late SignUpProvider _signUpProvider;

  Future<SignUpResponse> signUp({
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
