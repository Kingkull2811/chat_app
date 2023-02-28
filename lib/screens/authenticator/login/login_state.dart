import 'package:equatable/equatable.dart';

import '../../../utilities/enum/biometrics_button_type.dart';
import '../../../utilities/enum/highlight_status.dart';

abstract class AuthenticationState extends Equatable {
  //const AuthenticationState();

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

class LoginFormState {
  final HighlightStatus? buttonStatus;
  final BiometricButtonType? biometricButtonType;

  ///[isEnable] false = Disable, true = Enable for enable button Login
  final bool isEnable;

  ///[isSuccessAuthenticateBiometric] for button biometric available a device
  final bool isSuccessAuthenticateBiometric;

  /// status Authenticating Login
  final bool isAuthenticating;

  final String? errorMessage;

  LoginFormState({
    this.buttonStatus = HighlightStatus.notAvailable,
    this.biometricButtonType,
    this.isEnable = false,
    this.isSuccessAuthenticateBiometric = false,
    this.isAuthenticating = false,
    this.errorMessage,
  });
}

extension LoginFormStateExtension on LoginFormState {
  LoginFormState copyWith({
    HighlightStatus? buttonStatus,
    BiometricButtonType? biometricButtonType,
    bool? isEnable,
    bool? isSuccessAuthenticateBiometric,
    bool? isAuthenticating,
    String? errorMessage,
  }) =>
      LoginFormState(
        buttonStatus: buttonStatus ?? this.buttonStatus,
        biometricButtonType: biometricButtonType ?? this.biometricButtonType,
        isEnable: isEnable ?? this.isEnable,
        isSuccessAuthenticateBiometric: isSuccessAuthenticateBiometric ??
            this.isSuccessAuthenticateBiometric,
        isAuthenticating: isAuthenticating ?? this.isAuthenticating,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
