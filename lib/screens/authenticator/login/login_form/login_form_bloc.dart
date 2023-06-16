import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form_event.dart';
import 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final BuildContext context;

  LoginFormBloc(this.context) : super(LoginFormState()) {
    on((event, emit) async {
      if (event is ValidateForm) {
        emit(
          state.copyWith(
            isLoading: false,
            isEnable: event.isValidate,
          ),
        );
      }

      if (event is DisplayLoading) {
        emit(state.copyWith(isLoading: true));
      }
    });
  }
}
