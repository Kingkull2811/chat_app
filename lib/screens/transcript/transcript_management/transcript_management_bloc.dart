import 'package:chat_app/network/repository/class_repository.dart';
import 'package:chat_app/network/response/class_response.dart';
import 'package:chat_app/screens/transcript/transcript_management/transcript_management_event.dart';
import 'package:chat_app/screens/transcript/transcript_management/transcript_management_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/enum/api_error_result.dart';

class TranscriptManagementBloc
    extends Bloc<TranscriptManagementEvent, TranscriptManagementState> {
  final BuildContext context;

  final _classRepository = ClassRepository();

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
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listClass: [],
            ));
          }
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
