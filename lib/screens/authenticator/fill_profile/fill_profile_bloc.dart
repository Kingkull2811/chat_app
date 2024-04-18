import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/services/notification_services.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/student_firebase.dart';
import '../../../network/model/user_info_model.dart';
import '../../../services/firebase_services.dart';
import 'fill_profile_event.dart';
import 'fill_profile_state.dart';

class FillProfileBloc extends Bloc<FillProfileEvent, FillProfileState> {
  final _authRepository = AuthRepository();
  final SharedPreferencesStorage _pref = SharedPreferencesStorage();

  final BuildContext context;

  FillProfileBloc(this.context) : super(FillProfileState()) {
    on((event, emit) async {
      if (event is FillInit) {}

      if (event is FillProfile) {
        emit(state.copyWith(isLoading: true));

        final response = await _authRepository.fillProfile(
          userID: _pref.getUserId(),
          data: event.userMap,
        );
        if (response is UserInfoModel) {
          await _pref.setFullName(response.fullName ?? '');
          await _pref.setImageAvatarUrl(response.fileUrl ?? '');
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

          final Map<String, dynamic> data = {
            'id': response.id,
            'username': response.username,
            'email': response.email,
            'fullName': response.fullName,
            'phone': response.phone,
            'fileUrl': response.fileUrl,
            'parentOf': listToFirestore,
            'fcm_token': await FirebaseMessagingServices().getDeviceToken(),
          };

          await FirebaseService().uploadUserData(
            userId: _pref.getUserId(),
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
            fillSuccess: false,
            userData: null,
            apiError: ApiError.internalServerError,
          ));
        }
      }
    });
  }
}
