import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _authRepository = AuthRepository();
  final BuildContext context;

  ProfileBloc(this.context) : super(ProfileState()) {
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
          final response =
              await _authRepository.getUserInfo(userId: event.userID);
          if (response is UserInfoModel) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              userInfo: response,
            ));
          } else if (response is ExpiredTokenGetResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
            ));
          }
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
