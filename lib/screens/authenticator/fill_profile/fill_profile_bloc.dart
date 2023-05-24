import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/student_firebase.dart';
import '../../../network/model/user_info_model.dart';
import '../../../network/repository/student_repository.dart';
import '../../../services/firebase_services.dart';
import '../../../utilities/utils.dart';
import 'fill_profile_event.dart';
import 'fill_profile_state.dart';

class FillProfileBloc extends Bloc<FillProfileEvent, FillProfileState> {
  final _authRepository = AuthRepository();
  final _studentRepository = StudentRepository();

  final BuildContext context;

  FillProfileBloc(this.context) : super(FillProfileState()) {
    on((event, emit) async {
      if (event is FillInit) {}

      if (event is SearchStudentBySSID) {
        emit(state.copyWith(isLoading: true));
        final response = await _studentRepository.getStudentBySSID(
          studentSSID: event.studentSSID,
        );
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
          await SharedPreferencesStorage().setFullName(response.fullName ?? '');
          await SharedPreferencesStorage()
              .setImageAvartarUrl(response.fileUrl ?? '');
          final List<StudentFirebase>? listStudentFireBase = response.parentOf
              ?.map(
                (student) => StudentFirebase(
                  studentId: student.id.toString(),
                  studentName: student.name,
                  dob: student.dateOfBirth,
                  imageUrl: student.imageUrl,
                  className: student.className,
                ),
              )
              .toList();

          final List<Map<String, dynamic>>? listToFirestore =
              listStudentFireBase?.map((e) => e.toFirestore()).toList();
          String fcmToken = SharedPreferencesStorage().getFCMToken();
          if (isNullOrEmpty(fcmToken)) {
            fcmToken = await FirebaseService().getFCMToken();
          }

          final Map<String, dynamic> data = {
            'id': response.id,
            'username': response.username,
            'email': response.email,
            'fullName': response.fullName,
            'phone': response.phone,
            'fileUrl': response.fileUrl,
            'parentOf': listToFirestore,
            'fcm_token': fcmToken,
          };

          await FirebaseService().uploadUserData(
            userId: event.userId,
            data: data,
          );

          emit(state.copyWith(
            isLoading: false,
            fillSuccess: true,
            userData: response,
            apiError: ApiError.noError,
          ));
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
