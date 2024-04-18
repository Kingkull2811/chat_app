import 'package:chat_app/network/model/class_model.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/network/response/subject_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/repository/class_repository.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import 'class_info_event.dart';
import 'class_info_state.dart';

class ClassInfoBloc extends Bloc<ClassInfoEvent, ClassInfoState> {
  final BuildContext context;
  final _classRepository = ClassRepository();

  ClassInfoBloc(this.context) : super(ClassInfoState()) {
    on((event, emit) async {
      if (event is ClassInfoInit) {
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
          } else if (response is ExpiredTokenGetResponse && context.mounted) {
            logoutIfNeed(context);
            return;
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listSubject: [],
            ));
          }
        }
      }
      if (event is AddClassEvent) {
        emit(state.copyWith(isLoading: true));
        final response = await _classRepository.addClass(data: event.data);
        if (response is ClassModel) {
          emit(state.copyWith(
            isLoading: false,
            isAddSuccess: true,
          ));
        } else if (response is ExpiredTokenGetResponse && context.mounted) {
          logoutIfNeed(context);
          return;
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
            isAddSuccess: false,
          ));
        }
      }
      if (event is EditClassEvent) {
        emit(state.copyWith(isLoading: true));
        final response = await _classRepository.editClass(
          classId: event.classId,
          data: event.data,
        );
        if (response is ClassModel) {
          emit(state.copyWith(
            isLoading: false,
            isUpdateSuccess: true,
          ));
        } else if (response is ExpiredTokenGetResponse && context.mounted) {
          logoutIfNeed(context);
          return;
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
            isUpdateSuccess: false,
          ));
        }
      }
      if (event is DeleteClassEv) {
        await _classRepository.deleteClass(classId: event.classId);
      }
    });
  }
}
