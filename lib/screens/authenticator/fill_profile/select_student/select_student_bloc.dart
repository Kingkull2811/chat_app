import 'package:chat_app/screens/authenticator/fill_profile/select_student/select_student_event.dart';
import 'package:chat_app/screens/authenticator/fill_profile/select_student/select_student_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/repository/student_repository.dart';
import '../../../../network/response/base_response.dart';
import '../../../../network/response/student_response.dart';
import '../../../../utilities/screen_utilities.dart';

class SelectStudentBloc extends Bloc<SelectStudentEvent, SelectStudentState> {
  final _studentRepository = StudentRepository();
  final BuildContext context;

  SelectStudentBloc(this.context) : super(SelectStudentState()) {
    on((event, emit) async {
      if (event is SelectStudentEvent) {
        emit(state.copyWith(isLoading: true));

        final response = await _studentRepository.getStudentBySSID(
          studentSSID: event.studentSSID,
        );
        if (response is StudentResponse) {
          if (response.isOK()) {
            emit(state.copyWith(
              isLoading: false,
              isNotFind: false,
              apiError: ApiError.noError,
              studentInfo: response.data,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              isNotFind: true,
            ));
          }
        } else if (response is ExpiredTokenResponse) {
          logoutIfNeed(this.context);
        } else {
          emit(state.copyWith(
            isLoading: false,
            studentInfo: null,
          ));
        }
      }
    });
  }
}
