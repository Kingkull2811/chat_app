import 'dart:developer';

import 'package:chat_app/network/response/class_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/repository/class_repository.dart';
import '../../../utilities/enum/api_error_result.dart';
import 'class_management_event.dart';
import 'class_management_state.dart';

class ClassManagementBloc
    extends Bloc<ClassManagementEvent, ClassManagementState> {
  final _classRepository = ClassRepository();
  final BuildContext context;

  ClassManagementBloc(this.context) : super(ClassManagementState()) {
    on<ClassManagementEvent>((event, emit) async {
      if (event is InitClassEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _classRepository.getListClass();
          // final responseSubject = await _classRepository.getListSubject();

          log('class: $response');
          // log('subject: $responseSubject');
          if (response is ClassResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listClass: response.listClass,
            ));
            // } else if (responseSubject is SubjectResponse) {
            // emit(state.copyWith(listSubject: responseSubject.listSubject));
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listClass: [],
            ));
          }
        }
      }

      if (event is DeleteClassEvent) {
        await _classRepository.deleteClass(classId: event.classId);
      }
    });
  }
}
