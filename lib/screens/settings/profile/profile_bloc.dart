import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/enum/api_error_result.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(BuildContext context) : super(ProfileState()) {
    on((event, emit) async {
      if (event is GetUserInfo) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();

        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          //   final String email = await SharedPreferencesStorage().getUserEmail();
          //   final data = await FirebaseService().getUserInfoFirebase(
          //     email: email,
          //   );
          //   emit(state.copyWith(
          //     isLoading: false,
          //     userInfo: data,
          //     apiError: ApiError.noError,
          //   ));
        }
      }

      if (event is EditProfile) {
        emit(state.copyWith(
          isLoading: false,
          isEdit: true,
        ));
      }
    });
  }
}
