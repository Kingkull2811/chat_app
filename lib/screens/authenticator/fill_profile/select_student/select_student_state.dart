import 'package:chat_app/bloc/api_result_state.dart';

import '../../../../network/model/student.dart';
import '../../../../utilities/enum/api_error_result.dart';

class SelectStudentState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final bool isNotFind;
  final Student? studentInfo;

  SelectStudentState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.isNotFind = false,
    this.studentInfo,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;

  SelectStudentState copyWith({
    ApiError? apiError,
    bool? isLoading,
    bool? isNotFind,
    Student? studentInfo,
  }) =>
      SelectStudentState(
        apiError: apiError ?? this.apiError,
        isLoading: isLoading ?? this.isLoading,
        isNotFind: isNotFind ?? this.isNotFind,
        studentInfo: studentInfo ?? this.studentInfo,
      );
}
