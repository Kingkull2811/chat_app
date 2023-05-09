import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/network/model/error.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

class SignUpState implements ApiResultState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final List<Errors>? errors;
  final ApiError _apiError;

  SignUpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.errors,
    ApiError apiError = ApiError.noError,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension SignUpStateEx on SignUpState {
  SignUpState copyWith({
    ApiError? apiError,
    bool? isLoading,
    bool? isSuccess,
    String? message,
    List<Errors>? errors,
  }) =>
      SignUpState(
        apiError: apiError ?? this.apiError,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        message: message ?? this.message,
        errors: errors ?? this.errors,
      );
}
