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

class DisplayLoading extends LoginFormEvent {}

class LoginWithBiometrics extends LoginFormEvent {}
