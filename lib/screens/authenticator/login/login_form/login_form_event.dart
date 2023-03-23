import 'package:equatable/equatable.dart';

abstract class LoginFormEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidateForm extends LoginFormEvent {
  final bool isValidate;

  ValidateForm({
    this.isValidate = false,
  });
}

class DisplayLoading extends LoginFormEvent {
  final bool isLoading;

  DisplayLoading({
    this.isLoading = false,
  });
}

class OnSuccess extends LoginFormEvent {}

class OnFailure extends LoginFormEvent {
  final String? errorMessage;

  OnFailure({this.errorMessage});
}

class LoginWithBiometrics extends LoginFormEvent {}
