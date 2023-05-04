import 'package:chat_app/screens/authenticator/login/login_event.dart';
import 'package:chat_app/screens/authenticator/login/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, AuthenticationState> {
  LoginBloc(BuildContext context) : super(CheckAuthenticateInProgress()) {
    on((event, emit) async {
      if (event is CheckAuthenticationStarted) {
        emit(
          CheckAuthenticateInProgress(),
        );
      }
      if (event is CheckAuthenticationFailed) {
        emit(
          NotLogin(
            isShowLoginBiometrics: event.isShowBiometrics,
          ),
        );
      }
    });
  }
}
