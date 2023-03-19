import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {

  @override
  List<Object> get props => [];
}

class NotLogin extends AuthenticationState {
  final bool isShowLoginBiometrics;

  NotLogin({
    this.isShowLoginBiometrics = false,
  });
}

class CheckAuthenticateInProgress extends AuthenticationState {}
