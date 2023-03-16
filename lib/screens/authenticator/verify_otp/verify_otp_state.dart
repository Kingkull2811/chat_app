import 'package:chat_app/network/response/error_response.dart';

class VerifyOtpState {
  final bool isLoading;
  final String? message;
  final List<Errors>? errors;

  VerifyOtpState({
    this.isLoading = false,
    this.message,
    this.errors,
  });
}

extension VerifyOtpStateEx on VerifyOtpState {
  VerifyOtpState copyWith({
    bool? isLoading,
    String? message,
    List<Errors>? errors,
  }) =>
      VerifyOtpState(
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        errors: errors ?? this.errors,
      );
}
