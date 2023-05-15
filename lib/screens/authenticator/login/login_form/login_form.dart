import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_form/login_form_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_form/login_form_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_bloc.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/term_and_policy/term_and_policy.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/enum/highlight_status.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/input_field.dart';
import 'package:chat_app/widgets/input_password_field.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/animation_loading.dart';
import '../../../../widgets/custom_check_box.dart';
import '../../fill_profile/fill_profile.dart';
import '../../fill_profile/fill_profile_bloc.dart';
import '../../fill_profile/fill_profile_event.dart';
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

  final _formKey = GlobalKey<FormState>();

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
          // showLoading(context);
        }
        return GestureDetector(
          onTap: () {
            clearFocus(context);
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _loginForm(),
                      Column(
                        children: [
                          // _buildBiometricsButton(state),
                          _buttonLogin(context, state),
                          _goToSignUpPage(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loginForm() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 120,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/app_logo_light.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Welcome to \'app name\'',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Input(
                keyboardType: TextInputType.text,
                controller: _inputUsernameController,
                onChanged: (text) {
                  _validateForm();
                },
                textInputAction: TextInputAction.next,
                onSubmit: (_) => focusNode.requestFocus(),
                labelText: 'Username',
                hint: 'Enter your username',
                prefixIcon: Icons.person_outline,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: InputPasswordField(
                obscureText: !_isShowPassword,
                onTapSuffixIcon: () {
                  setState(() {
                    _isShowPassword = !_isShowPassword;
                  });
                },
                keyboardType: TextInputType.text,
                controller: _inputPasswordController,
                onChanged: (text) {},
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) async {
                  focusNode.requestFocus();
                  _validateForm();
                  if (_formKey.currentState!.validate()) {
                    await _handleButtonLogin(context);
                  }
                },
                labelText: 'Password',
                hint: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  } else if (value.length > 40) {
                    return 'Password must be more than 40 characters';
                  }
                  return null;
                },
              ),
            ),
            _rememberOrForgot(),
          ],
        ),
      ),
    );
  }

  Future<void> _goToTermPolicy() async {
    SharedPreferencesStorage().setLoggedOutStatus(false);
    bool agreedWithTerms = SharedPreferencesStorage().getAgreedWithTerms();
    if (mounted) {
      if (!agreedWithTerms) {
        _navigateToTerm();
      } else {
        // showLoading(context);
        final userInfo = await _authRepository.getUserInfo(
            userId: SharedPreferencesStorage().getUserId());
        if (userInfo is UserInfoModel) {
          userInfo.isFillProfileKey
              ? _navigateToMainPage()
              : _navigateToFillProfilePage(userInfo);
        }
      }
    }
  }

  _navigateToFillProfilePage(UserInfoModel userInfo) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<FillProfileBloc>(
            create: (context) => FillProfileBloc(context)..add(FillInit()),
            child: FillProfilePage(userInfo: userInfo),
          ),
        ),
      );

  _navigateToTerm() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const TermPolicyPage()));

  _navigateToMainPage() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => MainApp(currentTab: 0)));

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
                  : AppColors.greyLight,
            ),
          ),
        ),
      );
    }
    return const SizedBox(height: 142);
  }

  _validateForm() {
    setState(() {
      _loginFormBloc.add(ValidateForm(
        isValidate: (_inputUsernameController.text.isNotEmpty &&
            _inputPasswordController.text.isNotEmpty),
      ));
    });
  }

  Widget _buttonLogin(BuildContext context, LoginFormState state) {
    return PrimaryButton(
      text: 'Login',
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          await _handleButtonLogin(context);
        }
      },
    );
  }

  Future<void> _handleButtonLogin(BuildContext context) async {
    await SharedPreferencesStorage().setRememberInfo(_rememberInfo);

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none && mounted) {
      showMessageNoInternetDialog(context);
    } else {
      _loginFormBloc.add(DisplayLoading());
      final response = await _authRepository.login(
        username: _inputUsernameController.text,
        password: _inputPasswordController.text,
      );
      if (response.httpStatus == 200) {
        await SharedPreferencesStorage().setRememberInfo(true);
        await SharedPreferencesStorage().setSaveUserInfo(response.data);
        const Duration(milliseconds: 300);
        await _goToTermPolicy();
      } else {
        showCupertinoMessageDialog(
          this.context, 'Error',
          // content: response.errors?.first.errorMessage,
          content: 'Wrong username or password',
          onCloseDialog: () {
            _loginFormBloc.add(ValidateForm());
          },
        );
      }
    }
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<SignUpBloc>(
                  create: (context) => SignUpBloc(context),
                  child: const SignUpPage(),
                ),
              ),
            ),
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
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<ForgotPasswordBloc>(
                      create: (context) => ForgotPasswordBloc(context),
                      child: const ForgotPasswordPage(),
                    ),
                  ),
                );
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
