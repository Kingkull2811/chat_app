import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_form/login_form_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_form/login_form_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_bloc.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:chat_app/screens/term_and_policy/term_and_policy.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/enum/highlight_status.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/custom_check_box.dart';
import 'package:chat_app/widgets/input_field.dart';
import 'package:chat_app/widgets/input_password_field.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_form_state.dart';

class LoginFormPage extends StatefulWidget {
  final bool isShowLoginBiometrics;

  const LoginFormPage({
    super.key,
    this.isShowLoginBiometrics = false,
  });

  @override
  State<StatefulWidget> createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  final focusNode = FocusNode();
  final _inputUsernameController = TextEditingController();
  final _inputPasswordController = TextEditingController();
  bool _rememberInfo = false;
  bool _isShowPassword = false;

  late LoginFormBloc _loginFormBloc;

  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    _loginFormBloc = BlocProvider.of<LoginFormBloc>(context);
    if (widget.isShowLoginBiometrics) {
      Future.delayed(const Duration(microseconds: 500), () {
        _loginFormBloc.add(LoginWithBiometrics());
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _inputUsernameController.dispose();
    _inputPasswordController.dispose();
    _loginFormBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginFormBloc, LoginFormState>(
      listenWhen: (prevState, currState) {
        return currState.isSuccessAuthenticateBiometric;
      },
      listener: (context, state) {
        _goToTermPolicy();
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const AnimationLoading();
        }
        return GestureDetector(
          onTap: () {
            clearFocus(context);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/app_logo_light.png',
                                  height: 150,
                                  width: 150,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    'Welcome to \'app name\'',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: SizedBox(
                              height: 50,
                              child: Input(
                                keyboardType: TextInputType.text,
                                controller: _inputUsernameController,
                                onChanged: (text) {
                                  _validateForm();
                                },
                                textInputAction: TextInputAction.next,
                                onSubmit: (_) => focusNode.requestFocus(),
                                hint: 'Enter your username',
                                prefixIcon: Icons.person_outline,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: SizedBox(
                              height: 50,
                              child: InputPasswordField(
                                inputError: false,
                                obscureText: !_isShowPassword,
                                onTapSuffixIcon: () {
                                  setState(() {
                                    _isShowPassword = !_isShowPassword;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                controller: _inputPasswordController,
                                onChanged: (text) {},
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    focusNode.requestFocus(),
                                hint: 'Enter your password',
                                prefixIcon: Icons.lock_outline,
                              ),
                            ),
                          ),
                          _rememberOrForgot(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      children: [
                        _buildBiometricsButton(state),
                        _buttonLogin(state),
                        _goToSignUpPage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _goToTermPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstants.isLoggedOut, false);
    bool agreedWithTerms =
        prefs.getBool(AppConstants.agreedWithTermsKey) ?? false;
    if (mounted) {
      if (!agreedWithTerms) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TermPolicyPage(),
          ),
        );
      } else {
        showLoading(context);
        _navigateToMainPage();
      }
    }
  }

  _navigateToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TabBloc(),
          child: MainApp(
            navFromStart: true,
          ),
        ),
      ),
    );
  }

  _buildBiometricsButton(LoginFormState currentState) {
    if (currentState.buttonStatus != HighlightStatus.notAvailable) {
      return Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 32),
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _loginFormBloc.add(LoginWithBiometrics());
            },
            child: Image.asset(
              getBiometricsButtonPath(
                  buttonType: currentState.biometricButtonType),
              width: 80,
              height: 80,
              color: currentState.buttonStatus == HighlightStatus.active
                  ? Theme.of(context).primaryColor
                  : AppConstants().greyLight,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  _validateForm() {
    _loginFormBloc.add(ValidateForm(
      isValidate: (_inputUsernameController.text.isNotEmpty &&
          _inputPasswordController.text.isNotEmpty),
    ));
  }

  Widget _buttonLogin(LoginFormState currentState) {
    return PrimaryButton(
        text: 'Login',
        // isDisable: !currentState.isEnable,
        onTap:
            //currentState.isEnable ?
            () async {
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none && mounted) {
            showMessageNoInternetDialog(context);
          } else {
            _loginFormBloc.add(DisplayLoading(isLoading: true));
            final loginResult = await _authRepository.login(
              username: 'truong3', password: '123456',
              // username: _inputUsernameController.text.trim(),
              // password: _inputPasswordController.text.trim(),
            );
            //todo:::::
            print(loginResult);

            if (loginResult.isSuccess && mounted) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.setBool(
                  AppConstants.rememberInfo, _rememberInfo);

              await _goToTermPolicy();
            } else {
              _loginFormBloc.add(ValidateForm(isValidate: true));
              showCupertinoMessageDialog(
                context,
                'Error',
                content: loginResult.errors?.first.errorMessage,
                barrierDismiss: false,
              );
            }
          }
        });
  }

  Widget _goToSignUpPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Don\'t have an account? ',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<SignUpBloc>(
                    create: (context) => SignUpBloc(context),
                    child: const SignUpPage(),
                  ),
                ),
              );
            },
            child: Text(
              'Sign up',
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

  Widget _rememberOrForgot() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _rememberInfo = !_rememberInfo;
                });
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CustomCheckBox(
                      value: _rememberInfo,
                      onChanged: (value) {
                        setState(() {
                          _rememberInfo = value;
                        });
                      },
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Remember password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider<ForgotPasswordBloc>(
                              create: (context) => ForgotPasswordBloc(context),
                              child: const ForgotPasswordPage(),
                            )));
              },
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
