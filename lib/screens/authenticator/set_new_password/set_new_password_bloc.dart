import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_event.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetNewPasswordBloc
    extends Bloc<SetNewPasswordEvent, SetNewPasswordState> {
  SetNewPasswordBloc(BuildContext context) : super(SetNewPasswordState()) {
    on((event, emit) async {
      if (event is Validate) {
        emit(
          state.copyWith(
            isLoading: false,
            isEnable: event.isValidate,
          ),
        );
      }
      if (event is DisplayLoading) {
        emit(
          state.copyWith(
            isLoading: true,
          ),
        );
      }
      if (event is OnSuccess) {
        emit(
          state.copyWith(
            isLoading: false,
          ),
        );
      }
      if (event is OnFailure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: event.errorMessage,
          ),
        );
      }
    });
  }
}
