import 'package:chat_app/network/model/sign_up_result.dart';
import 'package:chat_app/network/repository/sign_up_repository.dart';
import 'package:chat_app/network/response/error_response.dart';
import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_bloc.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_state.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/input_field.dart';
import 'package:chat_app/widgets/input_password_field.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _isMatch = false;
  bool _isEnableButton = true;

  String validateMessage = '';

  late SignUpBloc _signUpBloc;
  final _signUpRepository = SignUpRepository();

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
    //showButton();
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

  void showButton() {
    if (_userNameController.text.trim().isEmpty &&
        _emailController.text.trim().isEmpty &&
        _passwordController.text.trim().isEmpty &&
        _confirmPasswordController.text.trim().isEmpty) {
      _isEnableButton = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
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
        // if (state is SignUpFailure) {
        //   List<Errors>? errors = state.errors;
        //   String errorMessage = '';
        //   for( var error in errors!){
        //     errorMessage = '$errorMessage\n${error.errorMessage}';
        //   }
        //
        //   showCupertinoMessageDialog(
        //     context,
        //     errorMessage,
        //     buttonLabel: 'OK',
        //     onCloseDialog: () {
        //       Navigator.pop(context);
        //     },
        //   );
        // }
      },
      builder: (context, state) {
        Widget body = const SizedBox.shrink();
        if (state.isLoading) {
          body = const AnimationLoading();
        } else {
          body = _body(state);
        }
        return Scaffold(body: body);
      },
    );
  }

  Widget _body(SignUpState state) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
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
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _inputTextField(
                      hintText: 'Enter username',
                      controller: _userNameController,
                      keyboardType: TextInputType.text,
                      iconLeading: Icon(
                        Icons.person_outline,
                        color: AppConstants().greyLight,
                        size: 24,
                      ),
                    ),
                    _inputTextField(
                      hintText: 'Enter email',
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      iconLeading: Icon(
                        Icons.mail_outline,
                        color: AppConstants().greyLight,
                        size: 24,
                      ),
                    ),
                    _inputPasswordField(
                      hintText: 'Enter password',
                      controller: _passwordController,
                      obscureText: !_isShowPassword,
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
                            _isShowConfirmPassword = !_isShowConfirmPassword;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              _buttonSignUp(state)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSignUp(SignUpState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0, bottom: 16),
      child: Column(
        children: [
          PrimaryButton(
            text: 'Sign Up',
            isDisable: !_isEnableButton,
            onTap: _isEnableButton
                ? () async {
                    ConnectivityResult connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult == ConnectivityResult.none &&
                        mounted) {
                      showMessageNoInternetDialog(context);
                    } else {
                      _signUpBloc.add(SignUpLoading());
                      SignUpResult? signUpResult =
                          await _signUpRepository.signUp(
                            //todo::::
                              // username: _userNameController.text.trim(),
                              // email: _emailController.text.trim(),
                              // password: _passwordController.text.trim(),
                              email: 'truong3@gmail.com',
                              username: 'truong3',
                              password: '123456');
                      print('signUpResult: $signUpResult');
                      if (mounted) {
                        if (signUpResult.isSuccess) {
                          _signUpBloc.add(
                            SignUpSuccess(message: signUpResult.message),
                          );
                          showSuccessBottomSheet(
                            context,
                            titleMessage: 'Sign Up Successfully!',
                            contentMessage: signUpResult.message ?? '',
                            buttonLabel: 'Login',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlocProvider<LoginFormBloc>(
                                        create: (context) => LoginFormBloc(context),
                                        child: const IDPassLoginForm(),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          _signUpBloc.add(
                            SignUpFailure(errors: signUpResult.errors),
                          );
                          String? errorMessage = '';
                          List<Errors>? errors = signUpResult.errors;
                          for (var error in errors!) {
                            errorMessage =
                                '$errorMessage\n${error.errorMessage}';
                          }
                          showCupertinoMessageDialog(
                            context,
                            errorMessage,
                            buttonLabel: 'OK',
                            onCloseDialog: () {
                              // Navigator.pop(context);
                            },
                          );
                        }
                      }
                    }
                  }
                : null,
          ),
          _goToLoginPage(),
        ],
      ),
    );
  }

  Widget _inputTextField({
    required String hintText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    Icon? iconLeading,
    String? prefixIconPath,
    int? maxText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 50,
        child: Input(
          keyboardType: keyboardType,
          maxText: maxText,
          controller: controller,
          onChanged: (text) {
            //_validateForm();
          },
          textInputAction: TextInputAction.next,
          onSubmit: (_) => focusNode.requestFocus(),
          hint: hintText,
          prefixIconPath: prefixIconPath,
          prefixIcon: iconLeading,
        ),
      ),
    );
  }

  Widget _inputPasswordField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    Function()? onTapSuffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 50,
        child: InputPasswordField(
          isInputError: false,
          obscureText: obscureText,
          onTapSuffixIcon: onTapSuffixIcon,
          keyboardType: TextInputType.text,
          controller: controller,
          onChanged: (text) {},
          textInputAction: TextInputAction.next,
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
                  builder: (context) => BlocProvider<LoginFormBloc>(
                    create: (context) => LoginFormBloc(context),
                    child: const IDPassLoginForm(),
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

  bool _validate() {
    RegExp emailExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    RegExp passwordExp =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

    if (!emailExp.hasMatch(_emailController.text.trim())) {
      setState(() {
        validateMessage = AppConstants.emailNotMatch;
      });
      return false;
    }
    if (!passwordExp.hasMatch(_passwordController.text.trim())) {
      setState(() {
        validateMessage = AppConstants.passwordNotMatch;
      });
      return false;
    }
    if (!emailExp.hasMatch(_emailController.text.trim()) &&
        !passwordExp.hasMatch(_passwordController.text.trim())) {
      setState(() {
        validateMessage = AppConstants.emailPasswordNotMatch;
      });
      return false;
    }

    return true;
  }
}
