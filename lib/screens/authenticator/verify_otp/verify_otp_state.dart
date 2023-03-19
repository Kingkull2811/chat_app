import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

class VerifyOtpState  implements ApiResultState{
  final bool isLoading;
  final String? errorMessage;
  final ApiError _apiError;
  final bool isEnable;

  VerifyOtpState({
    ApiError apiError = ApiError.noError,
    this.isLoading = false,
    this.errorMessage,
    this.isEnable = false,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension VerifyOtpStateEx on VerifyOtpState {
  VerifyOtpState copyWith({
    bool? isLoading,
    String? errorMessage,
    ApiError? apiError,
    bool? isEnable,
  }) =>
      VerifyOtpState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        apiError: apiError ?? this.apiError,
        isEnable: isEnable ?? this.isEnable,
      );
}
