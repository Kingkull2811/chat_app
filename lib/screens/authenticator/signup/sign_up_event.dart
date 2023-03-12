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


class SignupButtonPressed extends SignUpEvent {
  final String username;
  final String email;
  final String password;

  SignupButtonPressed(
      {required this.username, required this.email, required this.password});

  @override
  List<Object> get props => [username, email, password];

  @override
  String toString() =>
      'SignUpInfo: { username: $username, email: $email, password: $password }';
}

