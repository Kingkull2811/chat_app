import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_event.dart';
import 'package:chat_app/screens/authenticator/login/login_state.dart';
import 'package:chat_app/screens/term_and_policy/term_and_policy.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/model/login_result.dart';
import '../../../network/repository/login_repository.dart';
import '../../../utilities/app_constants.dart';
import '../../../utilities/enum/highlight_status.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/custom_check_box.dart';
import '../../../widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc? _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _checkAuthenticateState();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is NotLogin) {
          return BlocProvider<LoginFormBloc>(
            create: (BuildContext context) => LoginFormBloc(context),
            child: IDPassLoginForm(
              isShowLoginBiometrics: state.isShowLoginBiometrics,
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        );
      },
    );
  }

  void _checkAuthenticateState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool rememberInfo = preferences.getBool(AppConstants.rememberInfo) ?? false;
    bool isLoggedOut = preferences.getBool(AppConstants.isLoggedOut) ?? false;
    bool isExpired = true;
    String passwordExpireTime =
        preferences.getString(AppConstants.passwordExpireTimeKey) ?? '';

    if (passwordExpireTime.isNotEmpty) {
      try {
        if (DateTime.parse(passwordExpireTime).isAfter(DateTime.now())) {
          isExpired = false;
        }
      } catch (ignore) {
        if (kDebugMode) {
          print('password expired');
        }
      }
    }

    if (rememberInfo) {
      if (isLoggedOut) {
        if (isExpired) {
          _loginBloc?.add(CheckAuthenticationFailed());
        } else {
          _loginBloc?.add(
            CheckAuthenticationFailed(isShowBiometrics: true),
          );
        }
      } else {
        if (isExpired) {
          _loginBloc?.add(CheckAuthenticationFailed());
        } else {
          preferences.setBool(AppConstants.isLoggedOut, false);
          if (mounted) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => TermAndPolicy(),
            //   ),
            // );
          }
          DatabaseService().isShowingTerm = true;
        }
      }
    } else {
      if (isExpired) {
        _loginBloc?.add(CheckAuthenticationFailed());
      } else {
        _loginBloc?.add(
          CheckAuthenticationFailed(isShowBiometrics: true),
        );
      }
    }
  }
}

class IDPassLoginForm extends StatefulWidget {
  final bool isShowLoginBiometrics;

  const IDPassLoginForm({
    super.key,
    this.isShowLoginBiometrics = false,
  });

  @override
  State<StatefulWidget> createState() => _IDPassLoginFormState();
}

class _IDPassLoginFormState extends State<IDPassLoginForm> {
  final passwordFocusNode = FocusNode();
  final _inputPhoneController = TextEditingController();
  final _inputPasswordController = TextEditingController();
  bool _rememberInfo = false;

  LoginFormBloc? _loginFormBloc;

  final LoginRepository _loginRepository = LoginRepository();

  @override
  void initState() {
    _loginFormBloc = BlocProvider.of<LoginFormBloc>(context);
    if (widget.isShowLoginBiometrics) {
      Future.delayed(const Duration(microseconds: 500), () {
        _loginFormBloc?.add(LoginWithBiometrics());
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _inputPhoneController.dispose();
    _inputPasswordController.dispose();
    _loginFormBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final scrollHeight = MediaQuery.of(context).size.height - (16 + 50);
    //bool _isShowPassword = false;

    return BlocConsumer<LoginFormBloc, LoginFormState>(
      listenWhen: (previousState, currentState) {
        return currentState.isSuccessAuthenticateBiometric;
      },
      listener: (context, currentState) async {
        //await _goToTermAndPolicy();
      },
      builder: (context, currentState) {
        if (currentState.isAuthenticating) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            //clearFocus(context);
          },
          child: Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: true,
                body: SizedBox(
                  height: scrollHeight,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, padding.top, 16, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/app_logo_light.png',
                                  height: 150,
                                  width: 150,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Welcome to \'app name\'',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 5),
                            child: Text(
                              'Phone number',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.2,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Input(
                            keyboardType: TextInputType.phone,
                            maxText: 10,
                            controller: _inputPhoneController,
                            onChanged: (text) {
                              _validateForm();
                            },
                            textInputAction: TextInputAction.next,
                            onSubmit: (_) => passwordFocusNode.requestFocus(),
                            hint: 'Enter your phone number',
                            prefixIconPath: 'assets/images/ic_phone.png',
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 5),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.2,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Input(
                            controller: _inputPasswordController,
                            onChanged: (text) {
                              _validateForm();
                            },
                            textInputAction: TextInputAction.next,
                            onSubmit: (_) => passwordFocusNode.requestFocus(),
                            hint: 'Enter your password',
                            obscureText: true,
                            prefixIconPath: 'assets/images/ic_lock.png',
                            // suffixIconPath: _isShowPassword == true
                            //     ? 'assets/images/ic_eye_open.png'
                            //     : 'assets/images/ic_eye_close.png',
                            // onShowPassword: (){
                            //   setState(() {
                            //     _isShowPassword = !_isShowPassword;
                            //   });
                            // }
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
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
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                height: 1.2,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _buildBiometricsButton(currentState),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Don\'t hava a account? ',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Register',
                                    style: TextStyle(
                                      color: AppConstants().greyLight,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: _handleButton(currentState),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _handleButton(LoginFormState currentState) {
    if (currentState.isEnable) {
      return PrimaryButton(
        text: 'Login',
        onTap: () async {
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none && mounted) {
            showMessageNoInternetDialog(context);
          } else {
            _loginFormBloc?.add(DisplayLoading());
            LoginResult loginResult = await _loginRepository.login(
              phone: _inputPhoneController.text.trim(),
              password: _inputPasswordController.text.trim(),
            );
            if (loginResult.isSuccess && mounted) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.setBool(
                  AppConstants.rememberInfo, _rememberInfo);
              await _goToTermPolicy();
            } else if (loginResult.error == LoginError.incorrectLogin &&
                mounted) {
              _loginFormBloc?.add(ValidateForm(isValidate: true));
              showCupertinoMessageDialog(context, 'Error',
                  'Incorrect account registration phone number or password.',
                  barrierDismiss: false);
            } else {
              _loginFormBloc?.add(ValidateForm(isValidate: true));
              showCupertinoMessageDialog(
                  context, 'Error', 'Internal server error',
                  barrierDismiss: false);
            }
          }
        },
      );
    }
    return const PrimaryButton(
      onTap: null,
      text: 'Login',
    );
  }

  Future<void> _goToTermPolicy() async {
    (await SharedPreferences.getInstance())
        .setBool(AppConstants.isLoggedOut, false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TermPolicyPage()),
      );
      DatabaseService().isShowingTerm = true;
    }
  }

  _buildBiometricsButton(LoginFormState currentState) {
    if (currentState.buttonStatus != HighlightStatus.notAvailable) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _loginFormBloc?.add(LoginWithBiometrics());
            },
            child: Image.asset(
              getBiometricsButtonPath(
                  buttonType: currentState.biometricButtonType),
              width: 48,
              height: 48,
              color: currentState.buttonStatus == HighlightStatus.active
                  ? Theme.of(context).primaryColor
                  : AppConstants().greyLight,
            ),
          ),
        ),
      );
    }
    return const SizedBox(height: 100);
  }

  _validateForm() {
    _loginFormBloc?.add(ValidateForm(
      isValidate: (_inputPhoneController.text.isNotEmpty &&
          _inputPasswordController.text.isNotEmpty),
    ));
  }
}
