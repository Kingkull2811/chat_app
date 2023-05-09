import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_bloc.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_state.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/button_switch_icon.dart';
import 'package:chat_app/widgets/input_field.dart';
import 'package:chat_app/widgets/input_password_field.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/login_bloc.dart';
import '../login/login_form/login_form.dart';
import '../login/login_form/login_form_bloc.dart';
import '../login/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final focusNode = FocusNode();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isShowPassword = false;
  bool _isShowConfirmPassword = false;

  String messageValidate = '';
  String messageValidateEmail = '';
  bool hasCharacterEmail = false;
  bool hasCharacterPassword = false;
  bool checkValidateEmail = false;
  bool checkValidatePassword = false;
  bool errorEmail = false;
  bool errorPassword = false;
  bool isTeacher = false;

  late SignUpBloc _signUpBloc;

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
    _signUpBloc.add(ValidateForm());
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _signUpBloc.close();
    super.dispose();
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

  bool _validateEmail(value) {
    focusNode.requestFocus();
    if (value == null || value.isEmpty) {
      messageValidateEmail = 'Email is required';
      return false;
    }

    if (!AppConstants.emailExp.hasMatch(value)) {
      messageValidateEmail = AppConstants.emailNotMatch;
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(context, 'Error!',
              content: 'Internal_server_error');
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
        // if (curState.isSuccess) {
        //   showSuccessBottomSheet(
        //     context,
        //     titleMessage: 'Sign Up Successfully!',
        //     contentMessage: 'Please login!',
        //     buttonLabel: 'Login',
        //     onTap: () => _navigateToLogin(),
        //   );
        // }
        // if (!curState.isSuccess) {
        //   showCupertinoMessageDialog(
        //     context,
        //     'Error!',
        //     content: curState.message,
        //   );
        // }
      },
      builder: (context, curState) {
        Widget body = const SizedBox.shrink();
        if (curState.isLoading) {
          body = const AnimationLoading();
        } else {
          body = _body(curState);
        }

        return Scaffold(body: body);
      },
    );
  }

  _navigateToLogin() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<LoginFormBloc>(
            create: (context) => LoginFormBloc(context),
            child: const LoginFormPage(),
          ),
        ),
      );

  Widget _body(SignUpState state) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/app_logo_light.png',
                              height: 150,
                              width: 150,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Welcome sign up to \'app name\'',
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
                      _inputTextField(
                        hintText: 'Enter username',
                        controller: _userNameController,
                        onSubmit: (_) => focusNode.requestFocus(),
                        prefixIcon: Icons.person_outline,
                      ),
                      _inputTextField(
                          hintText: 'Enter email',
                          controller: _emailController,
                          prefixIcon: Icons.mail_outline,
                          onSubmit: (value) {}),
                      _inputPasswordField(
                        hintText: 'Enter password',
                        controller: _passwordController,
                        obscureText: !_isShowPassword,
                        onSubmitted: (_) => focusNode.requestFocus(),
                        onTapSuffixIcon: () {
                          setState(() {
                            _isShowPassword = !_isShowPassword;
                          });
                        },
                      ),
                      _inputPasswordField(
                          hintText: 'Confirm password',
                          controller: _confirmPasswordController,
                          obscureText: !_isShowConfirmPassword,
                          onTapSuffixIcon: () {
                            setState(
                              () {
                                _isShowConfirmPassword =
                                    !_isShowConfirmPassword;
                              },
                            );
                          },
                          onSubmitted: (_) {}),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: ButtonSwitchIcon(
                          title: "You are teacher?",
                          onToggle: (value) {
                            setState(() {
                              isTeacher = value;
                            });
                          },
                          value: isTeacher,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buttonSignUp(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSignUp(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 0.0, bottom: 16),
      child: Column(
        children: [
          PrimaryButton(
            text: 'Sign Up',
            onTap: () async {
              if (_userNameController.text.isEmpty) {
                showCupertinoMessageDialog(
                  context,
                  'Error!',
                  content: 'Username can\'t be empty',
                );
              } else if (_emailController.text.isEmpty) {
                showCupertinoMessageDialog(
                  context,
                  'Error!',
                  content: 'Email can\'t be empty',
                );
              } else if (_confirmPasswordController.text.isEmpty) {
                showCupertinoMessageDialog(
                  context,
                  'Error!',
                  content: 'Password can\'t be empty',
                );
              } else if (_passwordController.text.isEmpty) {
                showCupertinoMessageDialog(
                  context,
                  'Error!',
                  content: 'Password can\'t be empty',
                );
              } else if (_confirmPasswordController.text !=
                  _passwordController.text) {
                showCupertinoMessageDialog(
                  context,
                  'Error!',
                  content: 'Password and confirmation password must match',
                );
              } else {
                // showLoading(context);
                final Map<String, dynamic> data = {
                  "confirmPassword": _confirmPasswordController.text.trim(),
                  "email": _emailController.text.trim(),
                  "isFillProfileKey": false,
                  "password": _passwordController.text.trim(),
                  "roles": [isTeacher ? 'ROLE_USER' : 'ROLE_TEACHER'],
                  "username": _userNameController.text.trim()
                };
                // _signUpBloc.add(WaitingSignUp(userInfo: data));
                // setState(() {});
                final connectivity = await Connectivity().checkConnectivity();
                if (connectivity == ConnectivityResult.none) {
                } else {
                  final response = await AuthRepository().signUp(data: data);
                  if (response.isOK()) {
                    showSuccessBottomSheet(
                      this.context,
                      titleMessage: 'Sign Up Successfully!',
                      contentMessage: 'Please login!',
                      buttonLabel: 'Login',
                      onTap: () => _navigateToLogin(),
                    );
                  } else {
                    showCupertinoMessageDialog(
                      this.context,
                      'Error!',
                      content: response.errors?.first.errorMessage,
                    );
                  }
                }
              }
            },
          ),
          _goToLoginPage(),
        ],
      ),
    );
  }

  Widget _inputTextField(
      {required String hintText,
      required TextEditingController controller,
      IconData? prefixIcon,
      bool inputError = false,
      Function(String)? onSubmit}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        height: 50,
        child: Input(
          keyboardType: TextInputType.text,
          controller: controller,
          onChanged: (text) {
            //_validateForm();
          },
          isInputError: inputError,
          textInputAction: TextInputAction.next,
          onSubmit: onSubmit,
          hint: hintText,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }

  Widget _inputPasswordField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    Function()? onTapSuffixIcon,
    Function(String)? onSubmitted,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        height: 50,
        child: InputPasswordField(
          obscureText: obscureText,
          onTapSuffixIcon: onTapSuffixIcon,
          keyboardType: TextInputType.text,
          controller: controller,
          onChanged: (text) {},
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => focusNode.requestFocus(),
          hint: hintText,
          prefixIcon: Icons.lock_outline,
          validator: validator,
        ),
      ),
    );
  }

  Widget _goToLoginPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account? ',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<LoginBloc>(
                    create: (context) => LoginBloc(context),
                    child: const LoginPage(),
                  ),
                ),
              );
            },
            child: Text(
              'Login',
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
