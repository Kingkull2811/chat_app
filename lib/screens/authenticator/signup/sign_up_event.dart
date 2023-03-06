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

class SubmitButton extends SignUpEvent {
  final String username;
  final String email;
  final String password;

  SubmitButton(
      {required this.username, required this.email, required this.password});

  @override
  List<Object> get props => [username, email, password];

  @override
  String toString() =>
      'SignUpInfo: { username: $username, email: $email, password: $password }';
}
