import 'package:chat_app/network/response/error_response.dart';
import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ValidateForm extends SignUpEvent {
  final bool isValidate;

  ValidateForm({
    this.isValidate = false,
  });
}

class SignUpLoading extends SignUpEvent {}

class SignUpSuccess extends SignUpEvent {
  final String? message;

  SignUpSuccess({
    this.message,
  });
}

class SignUpFailure extends SignUpEvent {
  final List<Errors>? errors;

  SignUpFailure({this.errors});
}
