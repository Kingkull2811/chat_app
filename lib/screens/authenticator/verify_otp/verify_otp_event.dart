import 'package:chat_app/network/response/error_response.dart';
import 'package:equatable/equatable.dart';

abstract class VerifyOtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Validate extends VerifyOtpEvent {
  final bool isValidate;

  Validate({this.isValidate = false});
}

class DisplayLoading extends VerifyOtpEvent {}

class OnSuccess extends VerifyOtpEvent {}

class OnFailure extends VerifyOtpEvent {
  final List<Errors> errors;

  OnFailure({required this.errors});
}
