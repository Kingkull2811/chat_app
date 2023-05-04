import '../../bloc/api_result_state.dart';
import '../../utilities/enum/api_error_result.dart';

class TranscriptState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;

  TranscriptState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension TranscriptStateExtension on TranscriptState {
  TranscriptState copyWith({
    bool? isLoading,
    ApiError? apiError,
  }) =>
      TranscriptState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
      );
}
