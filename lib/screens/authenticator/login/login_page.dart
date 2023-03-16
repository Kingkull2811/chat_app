import 'package:chat_app/network/model/login_result.dart';
import 'package:chat_app/network/repository/login_repository.dart';
import 'package:chat_app/network/response/error_response.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_event.dart';
import 'package:chat_app/screens/authenticator/login/login_state.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_bloc.dart';
import 'package:chat_app/screens/term_and_policy/term_and_policy.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/enum/highlight_status.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/custom_check_box.dart';
import 'package:chat_app/widgets/input_field.dart';
import 'package:chat_app/widgets/input_password_field.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _checkAuthenticateState();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.close();
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
          _loginBloc.add(CheckAuthenticationFailed());
        } else {
          _loginBloc.add(
            CheckAuthenticationFailed(isShowBiometrics: true),
          );
        }
      } else {
        if (isExpired) {
          _loginBloc.add(CheckAuthenticationFailed());
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
        _loginBloc.add(CheckAuthenticationFailed());
      } else {
        _loginBloc.add(
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
  final focusNode = FocusNode();
  final _inputUsernameController = TextEditingController();
  final _inputPasswordController = TextEditingController();
  bool _rememberInfo = false;
  bool _isShowPassword = false;

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
    _inputUsernameController.dispose();
    _inputPasswordController.dispose();
    _loginFormBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final height = MediaQuery.of(context).size.height;
    //bool _isShowPassword = false;

    return BlocListener<LoginFormBloc, LoginFormState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          showDialog(
              context: context,
              builder: (context) => Container(
                    height: 300,
                    width: 300,
                    color: Colors.blue,
                  ));
        }
        if (state is AuthenticationSuccess) {
          _goToTermPolicy();
        }
      },
      child: BlocBuilder<LoginFormBloc, LoginFormState>(
        builder: (context, state) {
          if (state.isLoading) {
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
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  top: padding.top,
                  right: 16,
                  bottom: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: height - 120,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 20),
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
                          _inputUsernameField(),
                          _inputPasswordField(),
                          _rememberOrForgot(),
                        ],
                      ),
                    ),
                    _buildBiometricsButton(state),
                    _buttonLogin(state),
                    _goToSignUpPage(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
    return (currentState.buttonStatus != HighlightStatus.notAvailable)
        ? Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 32),
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _loginFormBloc?.add(LoginWithBiometrics());
                },
                child: Image.asset(
                  getBiometricsButtonPath(
                      buttonType: currentState.biometricButtonType),
                  width: 60,
                  height: 60,
                  color: currentState.buttonStatus == HighlightStatus.active
                      ? Theme.of(context).primaryColor
                      : AppConstants().greyLight,
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  _validateForm() {
    _loginFormBloc?.add(ValidateForm(
      isValidate: (_inputUsernameController.text.isNotEmpty &&
          _inputPasswordController.text.isNotEmpty),
    ));
  }

  Widget _buttonLogin(LoginFormState currentState) {
    return PrimaryButton(
        text: 'Login',
        onTap:
            //currentState.isEnable ?
            () async {
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none && mounted) {
            showMessageNoInternetDialog(context);
          } else {
            _loginFormBloc?.add(DisplayLoading(isLoading: true));
            LoginResult loginResult = await _loginRepository.login(
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
              //login
              //_loginFormBloc?.add(DisplayLoading());
              await _goToTermPolicy();
              // }else if(!loginResult.isSuccess){
              //   String? errorMessage = '';
              //   List<Errors>? errors = loginResult.errors;
              //   for (var error in errors!) {
              //     errorMessage =
              //     '$errorMessage\n${error.errorMessage}';
              //   }
              //   showCupertinoMessageDialog(
              //     context,
              //     errorMessage,
              //     buttonLabel: 'OK',
              //     onCloseDialog: () {
              //       // Navigator.pop(context);
              //     },
              //   );

            } else if (loginResult.error == LoginError.incorrectLogin &&
                mounted) {
              _loginFormBloc?.add(ValidateForm(isValidate: true));
              showCupertinoMessageDialog(
                context,
                'Error',
                content:
                    'Incorrect account registration phone number or password.',
                barrierDismiss: false,
              );
            } else {
              _loginFormBloc?.add(ValidateForm(isValidate: true));
              showCupertinoMessageDialog(
                context,
                'Error',
                content: 'Internal server error',
                barrierDismiss: false,
              );
            }
          }
        }
        // : () async {
        //    _goToTermPolicy();
        //  },
        );
  }

  Widget _goToSignUpPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
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
                    create: (context) => SignUpBloc(context: context),
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

  Widget _inputUsernameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24, bottom: 6),
            child: Text(
              'Username',
              style: TextStyle(
                fontSize: 12,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Input(
              keyboardType: TextInputType.text,
              maxText: 10,
              controller: _inputUsernameController,
              onChanged: (text) {
                _validateForm();
              },
              textInputAction: TextInputAction.next,
              onSubmit: (_) => focusNode.requestFocus(),
              hint: 'Enter your username',
              prefixIcon: const Icon(Icons.person_outline, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24, bottom: 6),
            child: Text(
              'Password',
              style: TextStyle(
                fontSize: 12,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: InputPasswordField(
              isInputError: false,
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
              onFieldSubmitted: (_) => focusNode.requestFocus(),
              hint: 'Enter your password',
              prefixIcon: Icons.lock_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rememberOrForgot() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 20,
        right: 16,
      ),
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
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider<ForgotPasswordBloc>(
                              create: (context) => ForgotPasswordBloc(),
                              child: const ForgotPasswordPage(),
                            )));
              },
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
    );
  }
}
