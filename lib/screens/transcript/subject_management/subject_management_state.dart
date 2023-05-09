import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/network/model/subject_model.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

class SubjectManagementState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<SubjectModel>? listSubject;

  SubjectManagementState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.listSubject,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension SubjectManagementStateEx on SubjectManagementState {
  SubjectManagementState copyWith({
    ApiError? apiError,
    bool? isLoading,
    List<SubjectModel>? listSubject,
  }) =>
      SubjectManagementState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listSubject: listSubject ?? this.listSubject,
      );
}
