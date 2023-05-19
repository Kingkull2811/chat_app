import 'dart:async';

import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_bloc.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp_bloc.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp_event.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyOtp extends StatefulWidget {
  final String email;

  const VerifyOtp({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  String _otpCode = '';

  final _authRepository = AuthRepository();

  late VerifyOtpBloc _verifyOtpBloc;
  int _timerCounter = 60;
  late Timer _timer;

  @override
  void initState() {
    _verifyOtpBloc = BlocProvider.of<VerifyOtpBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _verifyOtpBloc.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
      listenWhen: (previousState, currentState) {
        return currentState.apiError != ApiError.noError;
      },
      listener: (context, state) {
        if (state.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(
            context,
            'error',
            content: 'internal_server_error',
          );
        }
        if (state.apiError == ApiError.noInternetConnection) {
          showCupertinoMessageDialog(
            context,
            'error',
            content: 'no_internet_connection',
          );
        }
      },
      builder: (context, state) {
        Widget body = const SizedBox.shrink();
        if (state.isLoading) {
          body = const Scaffold(body: AnimationLoading());
        } else {
          body = _body(state);
        }
        return body;
      },
    );
  }

  Widget _body(VerifyOtpState state) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: 24,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 40,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Column(
                      children: <Widget>[
                        const Image(
                          image: AssetImage('assets/images/image_rating_1.png'),
                          fit: BoxFit.contain,
                          width: 250,
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'OTP Verification',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          width: 300,
                          child: Text(
                            'We will send you an onetime OTP code on the email: ${widget.email}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                        _otpTextField(),
                      ],
                    ),
                  ),
                  _reSendOtp(),
                  _buttonVerify(state)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: OtpTextField(
        numberOfFields: 6,
        fieldWidth: 45,
        textStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
        focusedBorderColor: Theme.of(context).primaryColor,
        enabledBorderColor: Theme.of(context).primaryColor,
        disabledBorderColor: Colors.grey,
        showFieldAsBox: true,
        borderWidth: 2.0,
        borderColor: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        //runs when a code is typed in
        onCodeChanged: (String code) {
          //handle validation or checks here if necessary
        },
        //runs when every text field is filled
        onSubmit: (String verificationCode) {
          setState(() {
            _otpCode = verificationCode;
            _verifyOtpBloc.add(Validate(isValidate: true));
          });
        },
      ),
    );
  }

  _buttonVerify(VerifyOtpState state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryButton(
        text: 'Verify',
        isDisable: !state.isEnable,
        onTap: state.isEnable
            ? () async {
                ConnectivityResult connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none && mounted) {
                  showMessageNoInternetDialog(context);
                } else {
                  _verifyOtpBloc.add(DisplayLoading());

                  final response = await _authRepository.verifyOtp(
                    email: widget.email,
                    otpCode: _otpCode,
                  );

                  if (response.isOK() && mounted) {
                    _verifyOtpBloc.add(OnSuccess());
                    showSuccessBottomSheet(
                      context,
                      enableDrag: false,
                      isDismissible: false,
                      titleMessage: 'Verified!',
                      contentMessage:
                          'You have verified verified your account.',
                      buttonLabel: 'Set a new password',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BlocProvider<SetNewPasswordBloc>(
                              create: (context) => SetNewPasswordBloc(context),
                              child: SetNewPassword(
                                email: widget.email,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // setState(() {
                    //   state.isLoading = false;
                    // });
                    _verifyOtpBloc.add(OnFailure(
                      errorMessage: response.errors?.first.errorMessage,
                    ));
                    _verifyOtpBloc.add(Validate(isValidate: false));
                  }
                }
              }
            : null,
      ),
    );
  }

  Widget _reSendOtp() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (_timerCounter > 0) {
          setState(() {
            _timerCounter--;
          });
        } else {
          _timer.cancel();
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Didn\'t you receive the OTP code? ',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () async {
              //todo: resend OTP code
              final response = await _authRepository.forgotPassword(
                email: widget.email,
              );
              if (response.isOK()) {
                setState(() {});
              }
            },
            child: Text(
              (_timerCounter == 0) ? 'Resend Code' : '00:$_timerCounter',
              // (duration.inSeconds == 0) ? 'Resend Code' : countTime,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
