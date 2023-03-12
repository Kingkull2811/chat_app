import '../../../network/response/error_response.dart';

abstract class SignUpState {}

class SignupInitial extends SignUpState {}

class SignupLoading extends SignUpState {}

class SignupSuccess extends SignUpState {
   final int? httpStatus;
   final String? message;

  SignupSuccess({this.httpStatus, this.message});
}

class SignupFailure extends SignUpState {
  final int? httpStatus;
  final String? message;
  final List<Errors>? error;

  SignupFailure({
    this.httpStatus,
    this.message,
    this.error,
  });
}
