import '../../../bloc/api_result_state.dart';
import '../../../utilities/enum/api_error_result.dart';

class OnChattingState implements ApiResultState{
  final bool isLoading;
  final ApiError _apiError;

  OnChattingState(
      {this.isLoading = false, ApiError apiError = ApiError.noError})
      : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension OnChattingStateExtension on OnChattingState {
  OnChattingState copyWith({
    bool? isLoading,
    ApiError? apiError,
  }) =>
      OnChattingState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
      );
}
