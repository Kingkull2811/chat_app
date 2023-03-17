import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on((event, emit) async {
      if (event is ValidateForm){
        emit(
          state.copyWith(
            isEnable: event.isValidate,
            isLoading: false,

          ),
        );
      }
      if (event is DisplayLoading){
        emit(
          state.copyWith(
            isLoading: true,
          ),
        );
      }
      if (event is OnSuccess){}
    });
  }
}
