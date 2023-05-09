import 'dart:developer';

import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './chat_event.dart';
import './chat_state.dart';
import '../../network/model/user_info_model.dart';
import '../../services/firebase_services.dart';
import '../../utilities/shared_preferences_storage.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final BuildContext context;
  final _firebaseService = FirebaseService();

  ChatsBloc(this.context) : super(ChatsState()) {
    on((event, emit) async {
      if (event is ChatInit) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final UserInfoModel? userInfo = await _firebaseService.getUserDetails(
            userId: SharedPreferencesStorage().getUserId(),
          );
          final List<UserInfoModel> listUser =
              await _firebaseService.getAllProfile();
          listUser.removeWhere((user) => user.id == userInfo?.id);

          log('user: $userInfo');
          log('list user: $listUser');

          if (userInfo != null) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              userData: userInfo,
              listUser: listUser,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              userData: null,
              listUser: listUser,
            ));
          }
        }
      }
    });
  }
}
