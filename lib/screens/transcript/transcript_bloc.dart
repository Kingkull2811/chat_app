import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './transcript_event.dart';
import './transcript_state.dart';
import '../../network/model/student.dart';
import '../../network/repository/learning_result_repository.dart';
import '../../network/response/learning_result_info_response.dart';
import '../../utilities/enum/api_error_result.dart';

class TranscriptBloc extends Bloc<TranscriptEvent, TranscriptState> {
  final _authRepository = AuthRepository();
  final _learningRepository = LearningResultInfoRepository();

  final BuildContext context;

  TranscriptBloc(this.context) : super(TranscriptState()) {
    on((event, emit) async {
      if (event is GetTranscriptByUserID) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();

        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final userResponse = await _authRepository.getUserInfo(
            userId: SharedPreferencesStorage().getUserId(),
          );

          if (userResponse is UserInfoModel) {
            final List<Student> listStudent = userResponse.parentOf ?? [];
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listStudent: listStudent,
            ));
          } else if (userResponse is ExpiredTokenGetResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listStudent: [],
            ));
          }
        }
      }

      if (event is GetLearningResult) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();

        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final Map<String, dynamic> queryParameters = {
            'studentId': event.studentId,
            'term': event.term,
            'year': event.year
          };

          final response = await _learningRepository.getListSubjectPoint(
            queryParameters: queryParameters,
          );

          if (response is LearningResultInfoResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              learningResult: response.listResult,
            ));
          } else if (response is ExpiredTokenGetResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              learningResult: [],
            ));
          }
        }
      }
    });
  }
}
