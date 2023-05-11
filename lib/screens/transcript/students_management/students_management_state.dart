import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

import '../../../network/model/student.dart';

class StudentManagementState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<Student>? listStudent;

  StudentManagementState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.listStudent,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension StudentManagementStateEx on StudentManagementState {
  StudentManagementState copyWith({
    ApiError? apiError,
    bool? isLoading,
    List<Student>? listStudent,
  }) =>
      StudentManagementState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listStudent: listStudent ?? this.listStudent,
      );
}
