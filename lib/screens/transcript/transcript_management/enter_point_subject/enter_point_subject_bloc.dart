import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/network/response/learning_result_info_response.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/repository/learning_result_repository.dart';
import '../../../../utilities/enum/api_error_result.dart';
import 'enter_point_subject_event.dart';
import 'enter_point_subject_state.dart';

class EnterPointSubjectBloc
    extends Bloc<EnterPointSubjectEvent, EnterPointSubjectState> {
  final BuildContext context;
  final _learningResultRepository = LearningResultInfoRepository();

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
          } else if (response is ExpiredTokenGetResponse) {
            Navigator.pop(this.context);
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listLearningInfo: [],
            ));
          }
        }
      }
      if (event is EnterPointSubjectEvent) {}
    });
  }
}
