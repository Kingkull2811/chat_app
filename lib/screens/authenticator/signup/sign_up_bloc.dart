import 'package:chat_app/screens/authenticator/signup/sign_up_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final BuildContext? context;

  SignUpBloc({this.context}) : super(SignUpState()) {
    on((event, emit) async {
      if (event is ValidateForm) {
        emit(state.copyWith(
          isLoading: false,
          isEnable: event.isValidate,
        ));
      }

      if (event is SignUpLoading) {
        emit(state.copyWith(
          isLoading: true,
        ));
      }
      if (event is SignUpSuccess) {
        emit(state.copyWith(
          isLoading: false,
          message: event.message,
        ));
      }
      if (event is SignUpFailure) {
        emit(state.copyWith(
          isLoading: false,
          errors: event.errors,
        ));
      }
    });
  }
}
