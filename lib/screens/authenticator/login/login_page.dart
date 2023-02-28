import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_event.dart';
import 'package:chat_app/screens/authenticator/login/login_state.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utilities/app_constants.dart';

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
  final bool _rememberInfo = false;

  LoginFormBloc? _loginFormBloc;
  //LoginRepository _loginRepository = LoginRepository;

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
                      padding: EdgeInsets.fromLTRB(16, padding.top, 16, 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 45, bottom: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/images/app_logo_light.png',
                                    height: 54),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
