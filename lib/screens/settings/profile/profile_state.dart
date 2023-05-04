import 'package:chat_app/network/model/user_info_model.dart';

import '../../../bloc/api_result_state.dart';
import '../../../utilities/enum/api_error_result.dart';

class ProfileState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final bool isEdit;
  final UserInfoModel? userInfo;

  ProfileState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.isEdit = false,
    this.userInfo,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ProfileStateExtension on ProfileState {
  ProfileState copyWith({
    bool? isLoading,
    ApiError? apiError,
    bool? isEdit,
    UserInfoModel? userInfo,
  }) =>
      ProfileState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        isEdit: isEdit ?? this.isEdit,
        userInfo: userInfo ?? userInfo,
      );
}
