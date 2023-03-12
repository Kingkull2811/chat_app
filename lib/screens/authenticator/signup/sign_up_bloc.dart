import 'dart:developer';

import 'package:chat_app/screens/authenticator/signup/sign_up_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/repository/sign_up_repository.dart';
import '../../../network/response/sign_up_response.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final BuildContext? context;
  final SignUpRepository? signUpRepository;

  SignUpBloc({ this.context, this.signUpRepository}) : super(SignupInitial()) {
    on((event, emit) async {
      if (event is SignupButtonPressed) {
        emit(SignupLoading());
        try {
          SignUpResponse? response = await signUpRepository?.signUp(
            email: event.email,
            password: event.password,
            username: event.username,
          );
          log(response.toString());
          if(response?.isOK()??false){
            emit(SignupSuccess( httpStatus: response?.httpStatus, message: response?.message,));
          }else{
            emit(
              SignupFailure(
                httpStatus: response?.httpStatus,
                message: response?.message,
                error: response?.error,
              ),
            );
          }

        } catch (error) {
          emit(SignupFailure());
        }
      }
    });
  }
}
