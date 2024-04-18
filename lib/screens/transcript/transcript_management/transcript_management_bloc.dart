import 'package:chat_app/network/repository/class_repository.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/network/response/class_response.dart';
import 'package:chat_app/screens/transcript/transcript_management/transcript_management_event.dart';
import 'package:chat_app/screens/transcript/transcript_management/transcript_management_state.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/repository/student_repository.dart';
import '../../../network/response/list_student_response.dart';
import '../../../utilities/enum/api_error_result.dart';

class TranscriptManagementBloc
    extends Bloc<TranscriptManagementEvent, TranscriptManagementState> {
  final BuildContext context;

  final _classRepository = ClassRepository();
  final _studentRepository = StudentRepository();

  TranscriptManagementBloc(this.context) : super(TranscriptManagementState()) {
    on((event, emit) async {
      if (event is InitTranscriptEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _classRepository.getListClass();

          if (response is ClassResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listClass: response.listClass,
            ));
          } else if (response is ExpiredTokenGetResponse && context.mounted) {
            logoutIfNeed(context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listClass: [],
            ));
          }
          final Map<String, dynamic> queryParameters = {
            // 'search': '',
            // 'classId': 0,
            'semesterYear': '2023-2024'
          };
          final responseStudent = await _studentRepository.getListStudent(
            queryParameters: queryParameters,
          );

          if (responseStudent is ListStudentsResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listStudent: responseStudent.listStudent,
            ));
          } else if (responseStudent is ExpiredTokenGetResponse && context.mounted) {
            logoutIfNeed(context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listStudent: [],
            ));
          }
        }
      }
      if (event is SearchEvent) {
        emit(state.copyWith(isLoading: true));
        final Map<String, dynamic> queryParameters = {
          'search': event.searchQuery,
          'classId': event.classId,
          'semesterYear': event.schoolYear
        };
        final response = await _studentRepository.getListStudent(
          queryParameters: queryParameters,
        );

        if (response is ListStudentsResponse) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
            listStudent: response.listStudent,
          ));
        } else if (response is ExpiredTokenGetResponse && context.mounted) {
          logoutIfNeed(context);
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
            listStudent: [],
          ));
        }
      }

      if (event is AddTranscriptEvent) {
        // emit(state.copyWith(isLoading: true));
        // final response = await _classRepository.addSubject(data: event.data);
        // if (response is SubjectModel) {
        //   emit(state.copyWith(
        //     isLoading: false,
        //     apiError: ApiError.noError,
        //   ));
        // } else {
        //   emit(state.copyWith(
        //     isLoading: false,
        //     apiError: ApiError.internalServerError,
        //   ));
        // }
      }
      if (event is EditTranscriptEvent) {
        // emit(state.copyWith(isLoading: true));
        // final response = await _classRepository.editSubject(
        //     subjectId: event.subjectId, data: event.data);
        //
        // if (response is SubjectModel) {
        //   emit(state.copyWith(
        //     isLoading: false,
        //     apiError: ApiError.noError,
        //   ));
        // } else {
        //   emit(state.copyWith(
        //     isLoading: false,
        //     apiError: ApiError.internalServerError,
        //   ));
        // }
      }
      if (event is DeleteTranscriptEvent) {
        // await _classRepository.deleteSubject(subjectId: event.subjectId);
      }
    });
  }
}
