import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/network/model/subject_model.dart';
import 'package:chat_app/network/repository/class_repository.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/repository/student_repository.dart';
import '../../../network/response/class_response.dart';
import '../../../network/response/list_student_response.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import 'students_management_event.dart';
import 'students_management_state.dart';

class StudentsManagementBloc
    extends Bloc<StudentsManagementEvent, StudentManagementState> {
  final _studentRepository = StudentRepository();
  final _classRepository = ClassRepository();
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
          final responseC = await _classRepository.getListClass();

          if (responseC is ClassResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listClass: responseC.listClass,
            ));
          } else if (responseC is ExpiredTokenGetResponse && context.mounted) {
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
          final response = await _studentRepository.getListStudent(
            queryParameters: queryParameters,
          );
          if (response is ListStudentsResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listStudent: response.listStudent,
            ));
          } else if (response is ExpiredTokenGetResponse  && context.mounted) {
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
          if (isNotNullOrEmpty(event.searchQuery)) 'search': event.searchQuery,
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
      if (event is AddStudentsEvent) {
        emit(state.copyWith(isLoading: true));
        final response = await _studentRepository.addStudent(data: event.data);
        if (response is SubjectModel) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
          ));
        } else if (response is ExpiredTokenGetResponse  && context.mounted) {
          logoutIfNeed(context);
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
        } else if (response is ExpiredTokenGetResponse && context.mounted) {
          Navigator.pop(context);
          logoutIfNeed(context);
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
