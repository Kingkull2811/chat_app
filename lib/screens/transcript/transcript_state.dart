import '../../bloc/api_result_state.dart';
import '../../network/model/learning_result_info.dart';
import '../../network/model/student.dart';
import '../../utilities/enum/api_error_result.dart';

class TranscriptState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<Student>? listStudent;
  final List<LearningResultInfo>? learningResult;

  TranscriptState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.listStudent,
    this.learningResult,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension TranscriptStateExtension on TranscriptState {
  TranscriptState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<Student>? listStudent,
    List<LearningResultInfo>? learningResult,
  }) =>
      TranscriptState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listStudent: listStudent ?? this.listStudent,
        learningResult: learningResult ?? this.learningResult,
      );
}
