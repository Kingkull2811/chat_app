import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/network/response/base_response.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_event.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/user_info_model.dart';
import '../../../utilities/utils.dart';

class FillProfileBloc extends Bloc<FillProfileEvent, FillProfileState> {
  final _authRepository = AuthRepository();
  final BuildContext context;

  FillProfileBloc(this.context) : super(FillProfileState()) {
    on((event, emit) async {
      if (event is GetUserInfoEvent) {
        final connectivityResult = await Connectivity().checkConnectivity();
        emit(state.copyWith(
          isLoading: true,
          apiError: ApiError.noError,
        ));

        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _authRepository.getUserInfo(
            userId: event.userId,
          );
          // log('getUserInfo: ${response.toString()}');
          if (response is UserInfoModel) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              userData: response,
              isUserRole: isUserRoles(listRole: response.roles),
            ));
          } else if (response is ExpiredTokenResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
            ));
            logoutIfNeed(context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
            ));
          }
        }
      }
      if (event is FillEvent) {
        emit(state.copyWith());
      }
    });
  }

  bool isUserRoles({required List<Role>? listRole}) {
    if (isNullOrEmpty(listRole)) {
      return true;
    }
    return listRole!.any((role) => role.id == 1 && role.name == 'ROLE_USER');
  }
}
