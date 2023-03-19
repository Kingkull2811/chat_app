import 'dart:math';

import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_bloc.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_event.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_state.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/input_password_field.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetNewPassword extends StatefulWidget {
  final String email;

  const SetNewPassword({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final focusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isShowPassword = false;
  bool _isShowRePassword = false;

  //for validate password
  String messageValidate = '';
  bool hasCharacter = false;
  bool checkValidatePassword = false;

  late SetNewPasswordBloc _newPasswordBloc;

  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    _newPasswordBloc = BlocProvider.of<SetNewPasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocConsumer<SetNewPasswordBloc, SetNewPasswordState>(
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
      ),
    );
  }

  Widget _body(SetNewPasswordState state) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                      title: 'New password',
                      hintText: 'Enter your new password',
                      controller: _passwordController,
                      obscureText: !_isShowPassword,
                      onTapSuffixIcon: () {
                        setState(() {
                          _isShowPassword = !_isShowPassword;
                        });
                      },
                      onSubmitted: (_) => focusNode.requestFocus(),
                    ),
                    _inputPasswordField(
                        title: 'Confirm new password',
                        hintText: 'Re-enter your new password',
                        controller: _confirmPasswordController,
                        obscureText: !_isShowRePassword,
                        onTapSuffixIcon: () {
                          setState(() {
                            _isShowRePassword = !_isShowRePassword;
                          });
                        },
                        onSubmitted: (_) {
                          focusNode.requestFocus();
                          setState(() {
                            hasCharacter = true;
                            checkValidatePassword = _validatePassword();
                          });
                        }),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: !hasCharacter
                          ? const SizedBox()
                          : checkValidatePassword
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      Icons.task_alt,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.cancel_outlined,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          16 * 4 -
                                          20 -
                                          10,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        messageValidate,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
              _buttonVerify(state)
            ],
          ),
        ),
      ),
    );
  }

  _buttonVerify(SetNewPasswordState state) {
    return PrimaryButton(
      text: 'Set a password',
      isDisable: !checkValidatePassword, //!state.isEnable,
      onTap: checkValidatePassword //state.isEnable
          ? () async {
              ConnectivityResult connectivityResult =
                  await Connectivity().checkConnectivity();
              if (connectivityResult == ConnectivityResult.none && mounted) {
                showMessageNoInternetDialog(context);
              } else {
                _newPasswordBloc.add(DisplayLoading());
                final response = await _authRepository.newPassword(
                  // email: widget.email,
                  email: 'truong3@gmail.com',
                  password: _passwordController.text.trim(),
                  confirmPassword: _confirmPasswordController.text.trim(),
                );
                //todo:::
                print(response);

                if (response.isSuccess && mounted) {
                  _newPasswordBloc.add(OnSuccess());
                  showSuccessBottomSheet(
                    context,
                    enableDrag: false,
                    isDismissible: false,
                    titleMessage: 'Successfully!',
                    contentMessage:
                        'You have successfully set a new password, please login.\n${response.message}',
                    buttonLabel: 'Login',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider<LoginBloc>(
                            create: (context) => LoginBloc(),
                            child: const LoginPage(),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  //iSuccess false
                }
              }
            }
          : null,
    );
  }

  bool _validatePassword() {
    if (_passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty) {
      messageValidate = 'Password cannot be empty';
      return false;
    }
    if (_passwordController.text.length < 6 &&
        _confirmPasswordController.text.length < 6 &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      messageValidate = 'Passwords must be at least 6 characters';
      return false;
    }

    if (_passwordController.text.trim() !=
            _confirmPasswordController.text.trim() &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      messageValidate = 'Password and confirm password do not match';
      return false;
    }

    return true;
  }

  Widget _inputPasswordField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    Function()? onTapSuffixIcon,
    bool obscureText = false,
    bool isInputError = false,
    String? Function(String?)? validator,
    Function(String?)? onSubmitted,
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
              inputError: isInputError,
              obscureText: obscureText,
              onTapSuffixIcon: onTapSuffixIcon,
              keyboardType: TextInputType.text,
              controller: controller,
              onChanged: (text) {},
              validator: validator,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: onSubmitted,
              hint: hintText,
              prefixIcon: Icons.lock_outline,
            ),
          ),
        ],
      ),
    );
  }
}
