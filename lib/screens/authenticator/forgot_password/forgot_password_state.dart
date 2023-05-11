import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

class ForgotPasswordState implements ApiResultState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSendCode;
  final ApiError _apiError;

  ForgotPasswordState({
    ApiError apiError = ApiError.noError,
    this.isLoading = false,
    this.isSendCode = false,
    this.errorMessage,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ForgotPasswordStateEx on ForgotPasswordState {
  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isSendCode,
    String? errorMessage,
    ApiError? apiError,
  }) =>
      ForgotPasswordState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        apiError: apiError ?? this.apiError,
        isSendCode: isSendCode ?? this.isSendCode,
      );
}
