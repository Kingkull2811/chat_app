import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_event.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_bloc.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_state.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/app_constants.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/input_password_field.dart';

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

  late SignUpBloc _signUpBloc;

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

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _registerForm(padding, height),
            _goToLoginPage(),
          ],
        ),
      ),
    );
  }

  Widget _registerForm(EdgeInsets padding, double height) {
    return BlocConsumer<SignUpBloc, SignUpState>(
        // listenWhen: (previousState, currentState){
        //   //return currentState;
        // },
        listener: (context, currentState) {
      return;
    }, builder: (context, currentState) {
      return Padding(
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
              child: Column(children: [
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
                  title: 'Username',
                  hintText: 'Enter your username',
                  controller: _userNameController,
                  keyboardType: TextInputType.text,
                  iconLeading: Icon(
                    Icons.person_outline,
                    color: AppConstants().greyLight,
                    size: 24,
                  ),
                ),
                _inputTextField(
                  title: 'Email',
                  hintText: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  iconLeading: Icon(
                    Icons.mail_outline,
                    color: AppConstants().greyLight,
                    size: 24,
                  ),
                ),
                _inputPasswordField(
                  title: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  obscureText: !_isShowPassword,
                  onTapSuffixIcon: () {
                    setState(() {
                      _isShowPassword = !_isShowPassword;
                    });
                  },
                ),
                _inputPasswordField(
                  title: 'Confirm password',
                  hintText: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  obscureText: !_isShowConfirmPassword,
                  onTapSuffixIcon: () {
                    setState(() {
                      _isShowConfirmPassword = !_isShowConfirmPassword;
                    });
                  },
                ),
              ]),
            ),
            _buttonSendOTP(currentState)
          ],
        ),
      );
    });
  }

  Widget _buttonSendOTP(SignUpState currentState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryButton(
        text: 'Sign Up',
        onTap: () async {
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none && mounted) {
            showMessageNoInternetDialog(context);
          } else {
            _signUpBloc.add(SubmitButton(
              username: _userNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ));

            showSuccessBottomSheet(
              context,
              titleMessage: 'Sign Up Successfully!',
              contentMessage:
                  'You have successfully sign up an account, please login',
              buttonLabel: 'Login',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<LoginFormBloc>(
                      create: (context) => LoginFormBloc(context),
                      child: IDPassLoginForm(),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _inputTextField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    Icon? iconLeading,
    String? prefixIconPath,
    int? maxText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
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
        ],
      ),
    );
  }

  Widget _inputPasswordField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    Function? onTapSuffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 6),
            child: Text(
              title,
              style: const TextStyle(
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
              obscureText: obscureText,
              onTapSuffixIcon: onTapSuffixIcon,
              keyboardType: TextInputType.text,
              controller: controller,
              onChanged: (text) {},
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => focusNode.requestFocus(),
              hint: hintText,
              prefixIconPath: 'assets/images/ic_lock.png',
            ),
          ),
        ],
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
                    child: IDPassLoginForm(),
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

  // _validateForm(){
  //   _registerBloc?.add(ValidateForm(isValidate: (_inputPhoneController.text.isNotEmpty
  //       && _inputFirstNameController.text.isNotEmpty
  //       && _inputLastNameController.text.isNotEmpty)));
  // }
}
