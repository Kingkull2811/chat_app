import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckAuthenticationStarted extends LoginEvent {}

class CheckAuthenticationFailed extends LoginEvent {
  final bool isShowBiometrics;

  CheckAuthenticationFailed({
    this.isShowBiometrics = false,
  });
}
