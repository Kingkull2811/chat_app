import '../../../bloc/api_result_state.dart';
import '../../../network/model/user_info_model.dart';
import '../../../utilities/enum/api_error_result.dart';

class FillProfileState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final UserInfoModel? userData;
  final bool isUserRole;

  FillProfileState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.userData,
    this.isUserRole = false,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;

  @override
  String toString() {
    return 'FillProfileState{isLoading: $isLoading, _apiError: $_apiError, userData: $userData}';
  }
}

extension FillProfileStateEx on FillProfileState {
  FillProfileState copyWith({
    ApiError? apiError,
    bool? isLoading,
    UserInfoModel? userData,
    bool? isUserRole,
  }) =>
      FillProfileState(
        apiError: apiError ?? this.apiError,
        isLoading: isLoading ?? this.isLoading,
        userData: userData ?? this.userData,
        isUserRole: isUserRole ?? this.isUserRole,
      );
}
