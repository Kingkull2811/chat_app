import 'package:chat_app/network/model/learning_result_info.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/network/response/base_response.dart';
import 'package:chat_app/network/response/learning_result_info_response.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/repository/learning_result_repository.dart';
import '../../../../network/repository/transcript_repository.dart';
import '../../../../utilities/enum/api_error_result.dart';
import 'enter_point_subject_event.dart';
import 'enter_point_subject_state.dart';

class EnterPointSubjectBloc
    extends Bloc<EnterPointSubjectEvent, EnterPointSubjectState> {
  final BuildContext context;
  final _learningResultRepository = LearningResultInfoRepository();
  final _transcriptRepository = TranscriptRepository();

  EnterPointSubjectBloc(this.context) : super(EnterPointSubjectState()) {
    on((event, emit) async {
      if (event is InitEvent) {
        emit(state.copyWith(isLoading: false));
      }
      if (event is GetListSubjectEvent) {
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
            'term': event.semester,
            'year': event.schoolYear
          };

          final response = await _learningResultRepository.getListSubjectPoint(
            queryParameters: queryParameters,
          );

          if (response is LearningResultInfoResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listLearningInfo: response.listResult,
            ));
          } else if (response is ExpiredTokenGetResponse && context.mounted) {
            logoutIfNeed(context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listLearningInfo: [],
            ));
          }
        }
      }
      if (event is UpdatePointEvent) {
        emit(state.copyWith(isLoading: true));

        for (LearningResultInfo learn in event.listResult) {
          final Map<String, dynamic> data = {
            "m15TestScore": learn.m15TestScore,
            "m45TestScore": learn.m45TestScore,
            "oralTestScore": learn.oralTestScore,
            "semesterTestScore": learn.semesterTestScore,
          };
          final response = await _transcriptRepository.updatePoint(
            id: learn.id!,
            data: data,
          );

          if (response is LearningResultInfo) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              updateDone: true,
            ));
          } else if (response is ExpiredTokenResponse  && context.mounted) {
            logoutIfNeed(context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              updateDone: false,
            ));
          }
        }

        emit(state.copyWith(isLoading: true));
        final mathResponse = await _transcriptRepository.mathGPA(
          studentID: event.studentID,
          schoolYear: event.schoolYear,
        );

        if (mathResponse.isOK()) {
          emit(state.copyWith(isLoading: false));
        } else if (mathResponse is ExpiredTokenResponse && context.mounted) {
          logoutIfNeed(context);
        } else {
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}
