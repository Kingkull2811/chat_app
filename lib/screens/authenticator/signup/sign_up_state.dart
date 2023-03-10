import 'package:equatable/equatable.dart';

abstract class SignUpState {}

class SignupInitial extends SignUpState {}

class SignupLoading extends SignUpState {}

class SignupSuccess extends SignUpState {}

class SignupFailure extends SignUpState {
  final String error;

  SignupFailure({
    required this.error,
  });
}
