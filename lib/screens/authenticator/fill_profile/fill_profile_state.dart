import '../../../bloc/api_result_state.dart';
import '../../../network/model/student.dart';
import '../../../network/model/user_info_model.dart';
import '../../../utilities/enum/api_error_result.dart';

class FillProfileState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final UserInfoModel? userData;
  final bool fillSuccess;
  final bool isNotFind;
  final Student? studentInfo;

  FillProfileState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.userData,
    this.fillSuccess = false,
    this.isNotFind = false,
    this.studentInfo,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;

  @override
  String toString() {
    return 'FillProfileState{isLoading: $isLoading, _apiError: $_apiError, userData: $userData, fillSuccess: $fillSuccess, studentInfo: $studentInfo}';
  }
}

extension FillProfileStateEx on FillProfileState {
  FillProfileState copyWith(
          {ApiError? apiError,
          bool? isLoading,
          UserInfoModel? userData,
          bool? fillSuccess,
          bool? isNotFind,
          Student? studentInfo}) =>
      FillProfileState(
        apiError: apiError ?? this.apiError,
        isLoading: isLoading ?? this.isLoading,
        userData: userData ?? this.userData,
        fillSuccess: fillSuccess ?? this.fillSuccess,
        isNotFind: isNotFind ?? this.isNotFind,
        studentInfo: studentInfo ?? this.studentInfo,
      );
}
