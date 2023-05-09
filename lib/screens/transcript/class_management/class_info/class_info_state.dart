import '../../../../bloc/api_result_state.dart';
import '../../../../network/model/subject_model.dart';
import '../../../../utilities/enum/api_error_result.dart';

class ClassInfoState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<SubjectModel>? listSubject;
  final bool isAddSuccess;
  final bool isUpdateSuccess;

  ClassInfoState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.listSubject,
    this.isAddSuccess = false,
    this.isUpdateSuccess = false,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ClassInfoStateEX on ClassInfoState {
  ClassInfoState copyWith(
          {ApiError? apiError,
          bool? isLoading,
          List<SubjectModel>? listSubject,
          bool? isAddSuccess,
          bool? isUpdateSuccess}) =>
      ClassInfoState(
          isLoading: isLoading ?? this.isLoading,
          apiError: apiError ?? this.apiError,
          listSubject: listSubject ?? this.listSubject,
          isAddSuccess: isAddSuccess ?? this.isAddSuccess,
          isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess);
}
