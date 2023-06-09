import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

import '../../../network/model/class_model.dart';
import '../../../network/model/student.dart';

class StudentManagementState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<Student>? listStudent;
  final List<ClassModel>? listClass;

  StudentManagementState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.listStudent,
    this.listClass,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;

  StudentManagementState copyWith({
    ApiError? apiError,
    bool? isLoading,
    List<Student>? listStudent,
    List<ClassModel>? listClass,
  }) =>
      StudentManagementState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listStudent: listStudent ?? this.listStudent,
        listClass: listClass ?? this.listClass,
      );
}
