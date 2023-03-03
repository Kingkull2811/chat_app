import 'dart:async';

import 'package:chat_app/screens/authenticator/register/register.dart';
import 'package:chat_app/screens/authenticator/register/register_bloc.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/screen_utilities.dart';
import '../set_new_password/set_new_password.dart';

class VerifyOTP extends StatefulWidget {
  final String? phoneNumber;

  const VerifyOTP({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final focusNode = FocusNode();
  final _otpController = List.generate(6, (index) => TextEditingController());
  bool isOtpSent = false;
  String? _otpCode;
  bool isEnableButton = true;

  int _timerCounter = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    // if (kDebugMode) {
    //   print("otpcCode: $_otpCode");
    // }

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
                  //Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<RegisterBloc>(
                        create: (context) => RegisterBloc(context),
                        child: RegisterPage(),
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/ic_back.png',
                  width: 24,
                  height: 24,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 40,
              child: Column(
                children: [
                  SizedBox(
                    height: height - 200,
                    child: Column(
                      children: <Widget>[
                        const Image(
                          image: AssetImage('assets/images/image_rating_1.png'),
                          fit: BoxFit.contain,
                          width: 250,
                          height: 200,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Text(
                            'OTP Verification',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          width: 300,
                          child: Column(
                            children: const [
                              Text(
                                'We will send you an onetime OTP code on the phone number:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '0123456789',
                                //widget.phoneNumber.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        _otpTextField(),
                      ],
                    ),
                  ),
                  _reSendOtp(),
                  _buttonVerify()
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          6,
          (index) => Container(
            height: 85,
            width: 55,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: TextField(
                autofocus: false,
                controller: _otpController[index],
                onChanged: (value) {
                  if (value.length == 1 && index < 5) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.isEmpty && index > 0) {
                    FocusScope.of(context).previousFocus();
                  }

                  //enable button when user input 6/6 otp code
                  //todo: using sms_autofill: ^2.3.0 https://pub.dev/packages/sms_autofill
                  // setState(() {
                  //   _otpCode = '$_otpCode$value';
                  // });
                },
                showCursor: false,
                readOnly: false,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                  hintText: '_',
                  counter: const Offstage(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(width: 1, color: AppConstants().greyLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: AppConstants().greyLight),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.pink),
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buttonVerify() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryButton(
        text: 'Verify',
        isDisable: !isEnableButton,
        onTap: isEnableButton
            ? () {
                showSuccessBottomSheet(
                  context,
                  enableDrag: false,
                  isDismissible: false,
                  titleMessage: 'Verified!',
                  contentMessage: 'You have successfully verified the account.',
                  buttonLabel: 'Set a new password',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetNewPassword(),
                      ),
                    );
                  },
                );
              }
            : null,
      ),
    );
  }

  Widget _reSendOtp() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_timerCounter > 0) {
          setState(() {
            _timerCounter--;
          });
        } else {
          _timer?.cancel();
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
            onTap: () {
              //todo: resend OTP code
            },
            child: Text(
              (_timerCounter == 0) ? 'Resend Code' : '00:$_timerCounter',
              style: TextStyle(
                color: AppConstants().greyLight,
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
