import 'package:chat_app/network/model/subject_model.dart';
import 'package:chat_app/network/repository/class_repository.dart';
import 'package:chat_app/network/response/subject_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/response/base_get_response.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import 'subject_management_event.dart';
import 'subject_management_state.dart';

class SubjectManagementBloc
    extends Bloc<SubjectManagementEvent, SubjectManagementState> {
  final _classRepository = ClassRepository();
  final BuildContext context;

  SubjectManagementBloc(this.context) : super(SubjectManagementState()) {
    on((event, emit) async {
      if (event is InitSubjectEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _classRepository.getListSubject();
          if (response is SubjectResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listSubject: response.listSubject,
            ));
          } else if (response is ExpiredTokenGetResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listSubject: [],
            ));
          }
        }
      }
      if (event is AddSubjectEvent) {
        emit(state.copyWith(isLoading: true));
        final response = await _classRepository.addSubject(data: event.data);
        if (response is SubjectModel) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
          ));
        }
      }
      if (event is EditSubjectEvent) {
        emit(state.copyWith(isLoading: true));
        final response = await _classRepository.editSubject(
            subjectId: event.subjectId, data: event.data);

        if (response is SubjectModel) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
          ));
        }
      }
      if (event is DeleteSubjectEvent) {
        await _classRepository.deleteSubject(subjectId: event.subjectId);
      }
    });
  }
}
