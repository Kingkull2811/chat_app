import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidateForm extends ForgotPasswordEvent {
  final bool isValidate;

  ValidateForm({this.isValidate = false});
}

class DisplayLoading extends ForgotPasswordEvent{}

class OnSuccess extends ForgotPasswordEvent{}
