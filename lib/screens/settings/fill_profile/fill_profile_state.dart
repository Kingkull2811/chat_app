import '../../../bloc/api_result_state.dart';
import '../../../network/model/user_info_model.dart';
import '../../../utilities/enum/api_error_result.dart';

class FillProfileState implements ApiResultState {
//   @override
//   List<Object?> get props => [];
// }
  final bool isLoading;
  final ApiError _apiError;
  final UserInfoModel? userData;
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
    return 'FillProfileState{isLoading: $isLoading, _apiError: $_apiError, userData: $userData}';
  }
}

extension FillProfileStateEx on FillProfileState {
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

// class FillProfileInit extends FillProfileState {}
//
// class DisplayLoading extends FillProfileState {}
//
// class ErrorState extends FillProfileState {
//   final bool isNoInternet;
//
//   ErrorState({this.isNoInternet = false});
// }
//
// class SuccessState extends FillProfileState {
//   final bool fillSuccess;
//   final UserInfoModel? userData;
//
//   SuccessState({this.fillSuccess = false, this.userData});
// }
