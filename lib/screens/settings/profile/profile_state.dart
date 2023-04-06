import '../../../bloc/api_result_state.dart';
import '../../../utilities/enum/api_error_result.dart';

class ProfileState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final bool isEdit;

  ProfileState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.isEdit = false,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ProfileStateExtension on ProfileState {
  ProfileState copyWith({
    bool? isLoading,
    ApiError? apiError,
    bool? isEdit,
  }) =>
      ProfileState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        isEdit: isEdit ?? this.isEdit,
      );
}
