import '../../../bloc/api_result_state.dart';
import '../../../network/model/user_info_model.dart';
import '../../../utilities/enum/api_error_result.dart';

class FillProfileState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  UserInfoModel? userData;
  final bool fillSuccess;

  FillProfileState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.userData,
    this.fillSuccess = false,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;

  @override
  String toString() {
    return 'FillProfileState{isLoading: $isLoading, _apiError: $_apiError, userData: $userData, fillSuccess: $fillSuccess}';
  }

  FillProfileState copyWith({
    ApiError? apiError,
    bool? isLoading,
    UserInfoModel? userData,
    bool? fillSuccess,
  }) =>
      FillProfileState(
        apiError: apiError ?? this.apiError,
        isLoading: isLoading ?? this.isLoading,
        userData: userData ?? this.userData,
        fillSuccess: fillSuccess ?? this.fillSuccess,
      );
}
