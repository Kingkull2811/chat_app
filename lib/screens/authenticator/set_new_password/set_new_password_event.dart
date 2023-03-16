import 'package:chat_app/network/response/error_response.dart';
import 'package:equatable/equatable.dart';

abstract class SetNewPasswordEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class Validate extends SetNewPasswordEvent {
  final bool isValidate;

  Validate({this.isValidate = false});
}

class DisplayLoading extends SetNewPasswordEvent {}

class OnSuccess extends SetNewPasswordEvent {}

class OnFailure extends SetNewPasswordEvent {
  final List<Errors> errors;

  OnFailure({required this.errors});
}
