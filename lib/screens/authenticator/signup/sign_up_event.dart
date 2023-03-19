import 'package:chat_app/network/response/error_data_response.dart';
import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Validate extends SignUpEvent {
  final bool isValidated;

  Validate({this.isValidated = false});
}

class SignUpLoading extends SignUpEvent {}

class SignUpSuccess extends SignUpEvent {
  final String? message;

  SignUpSuccess({this.message});
}

class SignUpFailure extends SignUpEvent {
  final List<Errors>? errors;

  SignUpFailure({required this.errors});
}
