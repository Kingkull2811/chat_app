import '../../bloc/api_result_state.dart';
import '../../utilities/enum/api_error_result.dart';

class ProfileState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;

  ProfileState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ProfileStateExtension on ProfileState {
  ProfileState copyWith({
    bool? isLoading,
    ApiError? apiError,
  }) =>
      ProfileState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
      );
}
