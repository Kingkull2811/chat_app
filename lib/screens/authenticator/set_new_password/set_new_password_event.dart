import 'package:equatable/equatable.dart';

abstract class SetNewPasswordEvent extends Equatable {
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
  final String errorMessage;

  OnFailure({required this.errorMessage});
}
