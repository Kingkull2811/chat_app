import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_event.dart';
import 'package:chat_app/screens/authenticator/login/login_form/login_form.dart';
import 'package:chat_app/screens/authenticator/login/login_form/login_form_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_state.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../term_and_policy/term_and_policy.dart';

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
            child: LoginFormPage(
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
    bool rememberInfo = SharedPreferencesStorage().getRememberInfo();
    bool isLoggedOut = SharedPreferencesStorage().getLoggedOutStatus();
    bool isExpired = true;
    String passwordExpireTime =
        SharedPreferencesStorage().getAccessTokenExpired();

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
          SharedPreferencesStorage().setLoggedOutStatus(false);
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TermPolicyPage(),
              ),
            );
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
