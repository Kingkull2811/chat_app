import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

import '../../../network/model/class_model.dart';

class ClassManagementState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<ClassModel>? listClass;

  ClassManagementState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.listClass,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension NewsStateExtension on ClassManagementState {
  ClassManagementState copyWith({
    ApiError? apiError,
    bool? isLoading,
    List<ClassModel>? listClass,
  }) =>
      ClassManagementState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listClass: listClass ?? this.listClass,
      );
}
