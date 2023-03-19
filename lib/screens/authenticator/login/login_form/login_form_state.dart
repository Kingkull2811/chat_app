import 'package:chat_app/utilities/enum/biometrics_button_type.dart';
import 'package:chat_app/utilities/enum/highlight_status.dart';

class LoginFormState {
  final HighlightStatus? buttonStatus;
  final BiometricButtonType? biometricButtonType;

  final bool isLoading;

  ///[isEnable] false = Disable, true = Enable for enable button Login
  final bool isEnable;

  ///[isSuccessAuthenticateBiometric] for button biometric available a device
  final bool isSuccessAuthenticateBiometric;

  final String? errorMessage;

  LoginFormState({
    this.buttonStatus = HighlightStatus.notAvailable,
    this.biometricButtonType,
    this.isEnable = false,
    this.isLoading = false,
    this.isSuccessAuthenticateBiometric = false,
    this.errorMessage,
  });
}

extension LoginFormStateExtension on LoginFormState {
  LoginFormState copyWith({
    HighlightStatus? buttonStatus,
    BiometricButtonType? biometricButtonType,
    bool? isEnable,
    bool? isSuccessAuthenticateBiometric,
    String? errorMessage,
    bool? isLoading,
  }) =>
      LoginFormState(
        buttonStatus: buttonStatus ?? this.buttonStatus,
        biometricButtonType: biometricButtonType ?? this.biometricButtonType,
        isEnable: isEnable ?? this.isEnable,
        isLoading: isLoading ?? this.isLoading,
        isSuccessAuthenticateBiometric: isSuccessAuthenticateBiometric ??
            this.isSuccessAuthenticateBiometric,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
