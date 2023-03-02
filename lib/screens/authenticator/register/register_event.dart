import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class ValidateForm extends RegisterEvent{
  final bool isValidate;

  ValidateForm({
    this.isValidate = false,
  });
}

class DisplayLoading extends RegisterEvent{}

class SubmissionFailed extends RegisterEvent{}

class RegisterSubmitted extends RegisterEvent{}