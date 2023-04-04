import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/network/model/error.dart';
import 'package:chat_app/screens/authenticator/login/login_form/login_form.dart';
import 'package:chat_app/screens/authenticator/login/login_form/login_form_bloc.dart';
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
import 'package:flutter/foundation.dart';
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

  String messageValidate = '';
  String messageValidateEmail = '';
  bool hasCharacterEmail = false;
  bool hasCharacterPassword = false;
  bool checkValidateEmail = false;
  bool checkValidatePassword = false;
  bool errorEmail = false;
  bool errorPassword = false;

  late SignUpBloc _signUpBloc;

  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
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
    // if (!AppConstants.passwordExp.hasMatch(_passwordController.text.trim())) {
    //   setState(() {
    //     messageValidateEmail = AppConstants.passwordNotMatch;
    //   });
    //   return false;
    // }
    // if (!AppConstants.emailExp.hasMatch(_emailController.text.trim()) &&
    //     !AppConstants.passwordExp.hasMatch(_passwordController.text.trim())) {
    //   setState(() {
    //     messageValidateEmail = AppConstants.emailPasswordNotMatch;
    //   });
    //   return false;
    // }
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
          showCupertinoMessageDialog(context, 'Error!',
              content: 'No_internet_connection');
        }
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
                                    color: Colors.black),
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
                          // inputError: hasCharacterEmail
                          //     ? errorEmail
                          //     ? true
                          //     : false
                          //     : false,
                          onSubmit: (value) {
                            hasCharacterEmail = true;
                            checkValidateEmail = _validateEmail(value);
                            errorEmail = !checkValidateEmail;
                          }),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: !hasCharacterEmail
                            ? const SizedBox()
                            : !checkValidateEmail
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.cancel_outlined,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                16 * 4 -
                                                20 -
                                                10,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          messageValidateEmail,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                      _inputPasswordField(
                        hintText: 'Enter password',
                        controller: _passwordController,
                        obscureText: !_isShowPassword,
                        onSubmitted: (_) => focusNode.requestFocus(),
                        inputError: hasCharacterPassword
                            ? errorPassword
                                ? true
                                : false
                            : false,
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
                          inputError: hasCharacterPassword
                              ? errorPassword
                                  ? true
                                  : false
                              : false,
                          onTapSuffixIcon: () {
                            setState(
                              () {
                                _isShowConfirmPassword =
                                    !_isShowConfirmPassword;
                              },
                            );
                          },
                          onSubmitted: (_) {
                            focusNode.requestFocus();
                            hasCharacterPassword = true;
                            checkValidatePassword = _validatePassword();
                            errorPassword = !checkValidatePassword;
                          }),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 8, right: 16,bottom: 8),
                        child: !hasCharacterPassword
                            ? const SizedBox()
                            : checkValidatePassword
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.cancel_outlined,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                16 * 4 -
                                                20 -
                                                10,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          messageValidate,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ],
                  ),
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
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 0.0, bottom: 16),
      child: Column(
        children: [
          PrimaryButton(
            text: 'Sign Up',
            isDisable: !checkValidatePassword,
            onTap: checkValidatePassword
                ? () async {
                    ConnectivityResult connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult == ConnectivityResult.none &&
                        mounted) {
                      showMessageNoInternetDialog(context);
                    } else {
                      _signUpBloc.add(SignUpLoading());
                      final response = await _authRepository.signUp(
                          //todo::::
                          username: _userNameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),);
                          // email: 'truong3@gmail.com',
                          // username: 'truong3',
                          // password: '123456');
                      if (kDebugMode) {
                        print(response);
                      }

                      if (response.isSuccess && mounted) {
                        _signUpBloc.add(
                          SignUpSuccess(message: response.message),
                        );
                        showSuccessBottomSheet(
                          context,
                          titleMessage: 'Sign Up Successfully!',
                          contentMessage: response.message ?? 'Please login!',
                          buttonLabel: 'Login',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<LoginFormBloc>(
                                  create: (context) => LoginFormBloc(context),
                                  child: const LoginFormPage(),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        _signUpBloc.add(
                          SignUpFailure(errors: response.errors),
                        );
                        String? errorMessage = '';
                        List<Errors>? errors = response.errors;
                        for (var error in errors!) {
                          errorMessage = '$errorMessage\n${error.errorMessage}';
                        }
                        showCupertinoMessageDialog(
                          context,
                          errorMessage,
                          buttonLabel: 'OK',
                          onCloseDialog: () {
                            Navigator.pop(context);
                          },
                        );
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
    bool inputError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
          inputError: inputError,
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
                    child: const LoginFormPage(),
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

// class _SignUpFormState extends State<SignUpForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   String? _passwordError;
//   String? _confirmPasswordError;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Validation succeeded, sign up the user
//     }
//   }
//
//   String? _validatePassword(String? password) {
//     if (password == null || password.isEmpty) {
//       return 'Password is required';
//     }
//
//     if (password.length < 6) {
//       return 'Password must be at least 6 characters long';
//     }
//
//     return null;
//   }
//
//   String? _validateConfirmPassword(String? confirmPassword) {
//     if (confirmPassword == null || confirmPassword.isEmpty) {
//       return 'Confirm password is required';
//     }
//
//     if (_passwordController.text != confirmPassword) {
//       return 'Passwords do not match';
//     }
//
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//             validator: AuthValidator.validateEmail,
//             onSaved: (value) {
//               // Save the email to the state
//             },
//             onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
//           ),
//           TextFormField(
//             controller: _passwordController,
//             decoration: InputDecoration(labelText: 'Password'),
//             validator: _validatePassword,
//             onSaved: (value) {
//               // Save the password to the state
//             },
//             obscureText: true,
//             onFieldSubmitted: (_) {
//               FocusScope.of(context).nextFocus();
//               setState(() {
//                 _passwordError = _validatePassword(_passwordController.text);
//               });
//             },
//           ),
//           if (_passwordError != null) Text(_passwordError!),
//           TextFormField(
//             controller: _confirmPasswordController,
//             decoration: InputDecoration(labelText: 'Confirm Password'),
//             validator: _validateConfirmPassword,
//             onSaved: (value) {
//               // Save the confirm password to the state
//             },
//             obscureText: true,
//             onFieldSubmitted: (_) {
//               FocusScope.of(context).unfocus();
//               setState(() {
//                 _confirmPasswordError = _validateConfirmPassword(_confirmPasswordController.text);
//               });
//             },
//           ),
//           if (_confirmPasswordError != null) Text(_confirmPasswordError!),
//           ElevatedButton(
//             onPressed: _submitForm,
//             child: Text('Sign Up'),
//           ),
//         ],
//       ),
//     );
//   }
// }
