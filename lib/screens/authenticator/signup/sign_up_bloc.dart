import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/repository/auth_repository.dart';
import '../../../utilities/enum/api_error_result.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final BuildContext context;

  final _authRepository = AuthRepository();

  SignUpBloc(this.context) : super(SignUpState()) {
    on((event, emit) async {
      if (event is ValidateForm) {
        emit(state.copyWith(isLoading: false));
      }
      if (event is WaitingSignUp) {
        emit(state.copyWith(isLoading: true));

        final connectivity = await Connectivity().checkConnectivity();
        if (connectivity == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _authRepository.signUp(data: event.userInfo);
          if (response.httpStatus == 200) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              isSuccess: true,
              message: response.message,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              isSuccess: false,
              apiError: ApiError.noError,
              message: response.errors?.first.errorMessage,
              errors: response.errors,
            ));
          }
        }
      }
    });
  }
}
