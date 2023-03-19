import 'package:equatable/equatable.dart';

import '../../../network/response/error_response.dart';

class ForgotPasswordState extends Equatable {
  final bool isLoading;
  final bool isEnable;
  final Errors? errors;

  const ForgotPasswordState({
    this.isLoading = false,
    this.isEnable = false,
    this.errors,
  });

  @override
  List<Object> get props => [];
}

extension ForgotPasswordStateEx on ForgotPasswordState {
  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isEnable,
    Errors? errors,
  }) =>
      ForgotPasswordState(
          isLoading: isLoading ?? this.isLoading,
          isEnable: isEnable ?? this.isEnable,
          errors: errors ?? this.errors);
}

// class Initial extends ForgotPasswordState {}
//
// class DisplayLoading extends ForgotPasswordState {}
//
// class OnSuccess extends ForgotPasswordState {}
//
// class OnFailure extends ForgotPasswordState {
//   final int? httpStatus;
//   final Errors? error;
//
//   OnFailure({
//     this.httpStatus,
//     this.error,
//   });
// }
