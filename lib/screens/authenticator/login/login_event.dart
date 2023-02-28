import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  //const LoginEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthenticationStarted extends LoginEvent {}

class CheckAuthenticationFailed extends LoginEvent {
  final bool isShowBiometrics;

  CheckAuthenticationFailed({
    this.isShowBiometrics = false,
  });
}

abstract class LoginFormEvent extends Equatable {
  //const LoginFormEvent();

  @override
  List<Object> get props => [];
}

class ValidateForm extends LoginFormEvent {
  final bool isValidate;

  ValidateForm({
    this.isValidate = false,
  });
}

class DisplayLoading extends LoginFormEvent {}

class LoginWithBiometrics extends LoginFormEvent {}
