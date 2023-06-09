import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/network/model/class_model.dart';
import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

class TranscriptManagementState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<Student>? listStudent;
  final List<ClassModel>? listClass;

  TranscriptManagementState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.listStudent,
    this.listClass,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;

  TranscriptManagementState copyWith({
    ApiError? apiError,
    bool? isLoading,
    List<Student>? listStudent,
    List<ClassModel>? listClass,
  }) =>
      TranscriptManagementState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listStudent: listStudent ?? this.listStudent,
        listClass: listClass ?? this.listClass,
      );
}
