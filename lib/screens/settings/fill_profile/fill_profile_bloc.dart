import 'dart:developer';

import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_event.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/user_info_model.dart';
import '../../../network/repository/student_repository.dart';

class FillProfileBloc extends Bloc<FillProfileEvent, FillProfileState> {
  final _authRepository = AuthRepository();
  final _studentRepository = StudentRepository();

  final BuildContext context;

  FillProfileBloc(this.context) : super(FillProfileState()) {
    on((event, emit) async {
      if (event is FillInit) {
        // emit(DisplayLoading());
        // final connectivityResult = await Connectivity().checkConnectivity();
        // if (connectivityResult == ConnectivityResult.none) {
        //   emit(ErrorState(isNoInternet: true));
        // } else {
        //   final response = await _authRepository.getUserInfo(
        //     userId: SharedPreferencesStorage().getUserId(),
        //   );
        //   if (response is UserInfoModel) {
        //     emit(SuccessState(fillSuccess: false, userData: response));
        //   } else {
        //     emit(ErrorState(isNoInternet: false));
        //   }
        // }
      }
      if (event is SearchStudentBySSID) {
        emit(state.copyWith(isLoading: true));
        final response = await _studentRepository.getStudentBySSID(
          studentSSID: event.studentSSID,
        );
        log(response.toString());
        if (response is Student) {
          emit(state.copyWith(
            isLoading: false,
            isNotFind: false,
            studentInfo: response,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            isNotFind: true,
          ));
        }
      }
      if (event is FillProfile) {
        emit(state.copyWith(isLoading: true));

        final response = await _authRepository.fillProfile(
          userID: event.userId,
          data: event.userData,
        );
        if (response is UserInfoModel) {
          log('user: $response');
          // await FirebaseService().uploadUserData(
          //     userId: event.userId,
          //     data: UserInfoModel(
          //       id: response.id,
          //       username: response.username,
          //       email: response.email,
          //       phone: response.phone,
          //       fullName: response.fullName,
          //       fileUrl: response.fileUrl,
          //       parentOf: response.parentOf,
          //     ).toFirestore());
          // emit(state.copyWith(
          //   isLoading: false,
          //   fillSuccess: true,
          //   userData: response,
          //   apiError: ApiError.noError,
          // ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            userData: null,
            apiError: ApiError.internalServerError,
          ));
        }
      }
    });
  }
}
