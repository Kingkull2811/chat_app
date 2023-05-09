import 'package:chat_app/network/model/error.dart';
import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ValidateForm extends SignUpEvent {}

class WaitingSignUp extends SignUpEvent {
  final Map<String, dynamic> userInfo;

  WaitingSignUp({required this.userInfo});

  @override
  List<Object?> get props => [userInfo];
}

class SignUpSuccess extends SignUpEvent {
  final String? message;

  SignUpSuccess({this.message});
}

class SignUpFailure extends SignUpEvent {
  final List<Errors>? errors;

  SignUpFailure({required this.errors});
}
