import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/authenticator/register/register_bloc.dart';
import 'package:chat_app/screens/authenticator/register/register_state.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/app_constants.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final focusNode = FocusNode();
  final _inputPhoneController = TextEditingController();
  final _inputFirstNameController = TextEditingController();
  final _inputLastNameController = TextEditingController();

  RegisterBloc? _registerBloc;

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _inputPhoneController.dispose();
    _inputFirstNameController.dispose();
    _inputLastNameController.dispose();
    _registerBloc?.close();
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
    return BlocConsumer<RegisterBloc, RegisterState>(
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
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'Welcome register to \'app name\'',
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
                  title: 'First Name',
                  hintText: 'Enter your first name',
                  controller: _inputFirstNameController,
                  keyboardType: TextInputType.text,
                  iconLeading: Icon(
                    Icons.person,
                    color: AppConstants().greyLight,
                    size: 24,
                  ),
                ),
                _inputTextField(
                  title: 'Last Name',
                  hintText: 'Enter your last name',
                  controller: _inputLastNameController,
                  keyboardType: TextInputType.text,
                  iconLeading: Icon(
                    Icons.person,
                    color: AppConstants().greyLight,
                    size: 24,
                  ),
                ),
                _inputTextField(
                    title: 'Phone Number',
                    hintText: 'Enter your phone number',
                    controller: _inputLastNameController,
                    keyboardType: TextInputType.number,
                    maxText: 10,
                    prefixIconPath: 'assets/images/ic_phone.png'),
              ]),
            ),
            _buttonSendOTP(
              currentState,
              _inputPhoneController.text,
            )
          ],
        ),
      );
    });
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

  Widget _buttonSendOTP(RegisterState currentState, String phoneNumber) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryButton(
        text: 'Send OTP',
        onTap: currentState.isEnable
            ? () async {
                ConnectivityResult connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none && mounted) {
                  showMessageNoInternetDialog(context);
                } else {
                  //todo: send otp to phone number
                  // _registerBloc?.add(DisplayLoading());
                }
              }
            //: null,
            //todo: remove
            : () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyOTP(
                      phoneNumber: phoneNumber,
                    ),
                  ),
                );
              },
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
                color: AppConstants().greyLight,
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
