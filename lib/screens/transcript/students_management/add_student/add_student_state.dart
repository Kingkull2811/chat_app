import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

import '../../../../network/model/class_model.dart';

class AddStudentState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<ClassModel>? listClass;
  final bool isAddSuccess;
  final bool isEditSuccess;
  final String? message;

  AddStudentState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.listClass,
    this.isAddSuccess = false,
    this.isEditSuccess = false,
    this.message,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension NewsStateExtension on AddStudentState {
  AddStudentState copyWith({
    ApiError? apiError,
    bool? isLoading,
    List<ClassModel>? listClass,
    bool? isAddSuccess,
    bool? isEditSuccess,
    String? message,
  }) =>
      AddStudentState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listClass: listClass ?? this.listClass,
        isAddSuccess: isAddSuccess ?? this.isAddSuccess,
        isEditSuccess: isEditSuccess ?? this.isEditSuccess,
        message: message ?? this.message,
      );
}
