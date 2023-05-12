import 'dart:developer';

import 'package:chat_app/network/repository/class_repository.dart';
import 'package:chat_app/network/response/class_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/model/student.dart';
import '../../../../network/repository/student_repository.dart';
import '../../../../network/response/base_get_response.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import 'add_student_event.dart';
import 'add_student_state.dart';

class AddStudentBloc extends Bloc<AddStudentEvent, AddStudentState> {
  final _classRepository = ClassRepository();
  final _studentRepository = StudentRepository();
  final BuildContext context;

  AddStudentBloc(this.context) : super(AddStudentState()) {
    on<AddStudentEvent>((event, emit) async {
      if (event is InitialEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _classRepository.getListClass();
          log('response News: $response ');

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
      if (event is AddStudentsEvent) {
        emit(state.copyWith(isLoading: true));

        final response = await _studentRepository.addStudent(data: event.data);
        if (response is Student) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
            isAddSuccess: true,
            message: 'Add new student success',
          ));
        } else if (response is ExpiredTokenGetResponse) {
          Navigator.pop(this.context);
          logoutIfNeed(this.context);
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
            isAddSuccess: false,
            message: 'Add student failed',
          ));
        }
      }
      if (event is EditStudentsEvent) {
        emit(state.copyWith(isLoading: true));
        final response = await _studentRepository.editStudent(
          studentId: event.studentID,
          data: event.data,
        );

        if (response is Student) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
            isEditSuccess: true,
            message: 'Update student success',
          ));
        } else if (response is ExpiredTokenGetResponse) {
          Navigator.pop(this.context);
          logoutIfNeed(this.context);
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
            isEditSuccess: false,
            message: 'Update student failed',
          ));
        }
      }
      if (event is DeleteStudentsEvent) {
        await _studentRepository.deleteStudent(studentId: event.studentID);
      }
    });
  }
}
