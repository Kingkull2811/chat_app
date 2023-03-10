import 'package:chat_app/screens/authenticator/signup/sign_up_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/repository/sign_up_repository.dart';
import '../../../network/response/base_response.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final BuildContext? context;
  final SignUpRepository? signUpRepository;

  SignUpBloc({ this.context, this.signUpRepository}) : super(SignupInitial()) {
    on((event, emit) async {
      if (event is SignupButtonPressed) {
        emit(SignupLoading());
        try {
          BaseResponse? response = await signUpRepository?.signUp(
            email: event.email,
            password: event.password,
            username: event.username,
          );
          if(response?.isOK()??false){
            emit(SignupSuccess());
          }

        } catch (error) {
          emit(SignupFailure(
            error: error.toString(),
          ));
        }
      }
    });
  }
}
