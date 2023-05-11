import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/network/model/subject_model.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/repository/student_repository.dart';
import '../../../network/response/list_student_response.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import 'students_management_event.dart';
import 'students_management_state.dart';

class StudentsManagementBloc
    extends Bloc<StudentsManagementEvent, StudentManagementState> {
  final _studentRepository = StudentRepository();
  final BuildContext context;

  StudentsManagementBloc(this.context) : super(StudentManagementState()) {
    on((event, emit) async {
      if (event is InitStudentsEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _studentRepository.getListStudent();
          if (response is ListStudentsResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listStudent: response.listStudent,
            ));
          } else if (response is ExpiredTokenGetResponse) {
            Navigator.pop(this.context);
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
      if (event is AddStudentsEvent) {
        emit(state.copyWith(isLoading: true));
        final response = await _studentRepository.addStudent(data: event.data);
        if (response is SubjectModel) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
          ));
        } else if (response is ExpiredTokenGetResponse) {
          Navigator.pop(this.context);
          logoutIfNeed(this.context);
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
          ));
        }
      }
      if (event is EditStudentsEvent) {
        emit(state.copyWith(isLoading: true));
        final response = await _studentRepository.editStudent(
            studentId: event.studentID, data: event.data);

        if (response is Student) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
          ));
        } else if (response is ExpiredTokenGetResponse) {
          Navigator.pop(this.context);
          logoutIfNeed(this.context);
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
          ));
        }
      }
      if (event is DeleteStudentsEvent) {
        await _studentRepository.deleteStudent(studentId: event.studentID);
      }
    });
  }
}
