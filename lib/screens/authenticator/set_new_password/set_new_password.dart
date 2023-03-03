import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_bloc.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_state.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/widgets/input_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/screen_utilities.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final focusNode = FocusNode();
  final _enterPasswordController = TextEditingController();
  final _reEnterPasswordController = TextEditingController();
  bool _isShowPassword = false;
  bool _isShowRePassword = false;
  final bool _isPasswordStrong = false;
  final bool _isSame = false;
  final bool _isValidatePassword = false;

  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _enterPasswordController.dispose();
    _reEnterPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: _newPasswordForm(height, width),
      ),
    );
  }

  Widget _newPasswordForm(double height, double width) {
    // return BlocConsumer<SetNewPasswordBloc, SetNewPasswordState>(
    //   // listenWhen: (previousState, currentState){
    //   //   return;
    //   // },
    //   listener: (context, currentState) {
    //     return;
    //   },
    //   builder: (context, currentState) {
    return SingleChildScrollView(
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Image.asset(
                      'assets/images/app_logo_light.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  const Text(
                    'Set a new password',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                  _inputPasswordField(
                      title: 'Enter new password',
                      hintText: 'Enter your new password',
                      controller: _enterPasswordController,
                      obscureText: !_isShowPassword,
                      onTapSuffixIcon: () {
                        setState(() {
                          _isShowPassword = !_isShowPassword;
                        });
                      },
                      //isInputError: _isPasswordStrong,
                      //validator: () {}
                    ),
                  _inputPasswordField(
                      title: 'Re-Enter new password',
                      hintText: 'Re-enter your new password',
                      controller: _reEnterPasswordController,
                      obscureText: !_isShowRePassword,
                      onTapSuffixIcon: () {
                        setState(() {
                          _isShowRePassword = !_isShowRePassword;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please re-enter password';
                        }
                        if (_enterPasswordController.text !=
                            _reEnterPasswordController.text) {
                          return 'Password does not match';
                        }
                        return null;
                      }),
                  Container(
                    width: width - 16 * 4,
                    padding: const EdgeInsets.only(top: 24),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/ic_x_red.png',
                          //'assets/image/ic_v_green.png',
                          width: 24,
                          height: 24,
                          color: AppConstants().red700,
                          // AppConstants().green600,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Password is not strong enough',
                            //'Password does not match',
                            //'Strong password',
                            //'Password do match',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buttonVerify()
          ],
        ),
      ),
    );
    //   },
    // );
  }

  _buttonVerify() {
    return PrimaryButton(
      text: 'Register',
      onTap: () {
        showSuccessBottomSheet(
          context,
          enableDrag: false,
          isDismissible: false,
          titleMessage: 'Register Successfully!',
          contentMessage:
              'You have successfully register an account, please login.',
          buttonLabel: 'Login',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(),
                  child: LoginPage(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _inputPasswordField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    Function? onTapSuffixIcon,
    bool obscureText = false,
    bool isInputError = false,
    Function? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: InputPasswordField(
              isInputError: isInputError,
              obscureText: obscureText,
              onTapSuffixIcon: onTapSuffixIcon,
              keyboardType: TextInputType.text,
              controller: controller,
              onChanged: (text) {},
              validator: validator,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => focusNode.requestFocus(),
              hint: hintText,
              prefixIconPath: 'assets/images/ic_lock.png',
            ),
          ),
        ],
      ),
    );
  }
}
