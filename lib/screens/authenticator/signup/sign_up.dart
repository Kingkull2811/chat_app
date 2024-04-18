import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_bloc.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_state.dart';
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

import '../../../utilities/app_constants.dart';
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

  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(context, context.l10n.error, content: context.l10n.internal_server_error);
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
      },
      builder: (context, curState) {
        Widget body = const SizedBox.shrink();
        if (curState.isLoading) {
          body = const AnimationLoading();
        } else {
          body = _body(curState);
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(body: body),
        );
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/app_logo_light.png',
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              // const Padding(
                              //   padding: EdgeInsets.only(top: 10),
                              //   child: Text(
                              //     'Welcome sign up to \'app name\'',
                              //     style: TextStyle(
                              //       fontSize: 22,
                              //       fontWeight: FontWeight.w900,
                              //       color: Colors.black,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        _inputTextField(
                          labelText: context.l10n.username,
                          // hintText: 'Enter username',
                          controller: _userNameController,
                          onSubmit: (_) => focusNode.requestFocus(),
                          prefixIcon: Icons.person_outline,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return context.l10n.enter_username;
                            }
                            return null;
                          },
                        ),
                        _inputTextField(
                          labelText: context.l10n.email,
                          // hintText: 'Enter email',
                          controller: _emailController,
                          prefixIcon: Icons.mail_outline,
                          onSubmit: (value) {},
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return context.l10n.enter_email;
                            } else if (!AppConstants.emailExp.hasMatch(value)) {
                              return context.l10n.valid_email;
                            }
                            return null;
                          },
                        ),
                        _inputPasswordField(
                          labelText: context.l10n.password,
                          // hintText: 'Enter password',
                          controller: _passwordController,
                          obscureText: !_isShowPassword,
                          onSubmitted: (_) => focusNode.requestFocus(),
                          onTapSuffixIcon: () {
                            setState(() {
                              _isShowPassword = !_isShowPassword;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return context.l10n.enterPassword;
                            }
                            if (value.isNotEmpty && value.length < 6) {
                              return context.l10n.passwordLeast;
                            } else if (value.length > 40) {
                              return context.l10n.passwordLess;
                            }
                            return null;
                          },
                        ),
                        _inputPasswordField(
                          labelText: context.l10n.confirmPass,
                          // hintText: 'Enter confirm password',
                          controller: _confirmPasswordController,
                          obscureText: !_isShowConfirmPassword,
                          onTapSuffixIcon: () {
                            setState(
                              () {
                                _isShowConfirmPassword = !_isShowConfirmPassword;
                              },
                            );
                          },
                          onSubmitted: (_) {},
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return context.l10n.enterConPass;
                            } else if (value.length < 6) {
                              return context.l10n.passwordLeast;
                            } else if (value.length > 40) {
                              return context.l10n.passwordLess;
                            } else if (value != _passwordController.text) {
                              return context.l10n.passwordMatch;
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: ButtonSwitchIcon(
                            title: context.l10n.isTeacher,
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
            text: context.l10n.signUp,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                final Map<String, dynamic> data = {
                  "confirmPassword": _confirmPasswordController.text.trim(),
                  "email": _emailController.text.trim(),
                  "isFillProfileKey": false,
                  "password": _passwordController.text.trim(),
                  "roles": [!isTeacher ? 'ROLE_USER' : 'ROLE_TEACHER'],
                  "username": _userNameController.text.trim()
                };
                // _signUpBloc.add(WaitingSignUp(userInfo: data));
                final connectivity = await Connectivity().checkConnectivity();
                if (connectivity == ConnectivityResult.none) {
                } else {
                  final response = await AuthRepository().signUp(data: data);
                  if (response.isOK() && context.mounted) {
                    showSuccessBottomSheet(
                      this.context,
                      titleMessage: context.l10n.successfully,
                      contentMessage: context.l10n.plsLogin,
                      buttonLabel: context.l10n.login,
                      onTap: () => _navigateToLogin(),
                    );
                  } else {
                    showCupertinoMessageDialog(
                      this.context,
                      context.l10n.error,
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

  Widget _inputTextField({
    String? hintText,
    String? labelText,
    required TextEditingController controller,
    IconData? prefixIcon,
    Function(String)? onSubmit,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Input(
        validator: validator,
        keyboardType: TextInputType.text,
        controller: controller,
        onChanged: (_) {},
        textInputAction: TextInputAction.next,
        onSubmit: onSubmit,
        hint: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
      ),
    );
  }

  Widget _inputPasswordField({
    String? hintText,
    String? labelText,
    required TextEditingController controller,
    bool obscureText = false,
    Function()? onTapSuffixIcon,
    Function(String)? onSubmitted,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: InputPasswordField(
        obscureText: obscureText,
        onTapSuffixIcon: onTapSuffixIcon,
        keyboardType: TextInputType.text,
        controller: controller,
        onChanged: (text) {},
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => focusNode.requestFocus(),
        hint: hintText,
        labelText: labelText,
        prefixIcon: Icons.lock_outline,
        validator: validator,
      ),
    );
  }

  Widget _goToLoginPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.alreadyAcc,
            style: const TextStyle(fontSize: 14),
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
              context.l10n.login,
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
    );
  }
}
