import 'package:chat_app/screens/authenticator/login/login_bloc.dart';
import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_bloc.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/screen_utilities.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final focusNode = FocusNode();
  final _enterPasswordController = TextEditingController();
  final _reEnterPasswordController = TextEditingController();
  final bool _isPasswordStrong = false;
  final bool _isSame = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _enterPasswordController.dispose();
    _reEnterPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            'Set new password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: _newPasswordForm(height),
      ),
    );
  }

  Widget _newPasswordForm(double height) {
    return BlocConsumer<SetNewPasswordBloc, SetNewPasswordState>(
      // listenWhen: (previousState, currentState){
      //   return;
      // },
      listener: (context, currentState) {
        return;
      },
      builder: (context, currentState) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: height - 200,
                  child: Column(
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                      _inputTextField(
                        title: 'Enter new password',
                        hintText: 'Enter your new password',
                        controller: _enterPasswordController,
                        keyboardType: TextInputType.text,
                      ),
                      _inputTextField(
                        title: 'Re-Enter new password',
                        hintText: 'Re-Enter your new password',
                        controller: _reEnterPasswordController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ),

              _buttonVerify()
            ],
          ),
        );
      },
    );
  }

  _buttonVerify() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryButton(
        text: 'Register',
        onTap: () {
          showSuccessBottomSheet(
            context,
            enableDrag: false,
            isDismissible: false,
            titleMessage: 'Register Successfully!',
            contentMessage: 'You have successfully register an account,\n please login.',
            buttonLabel: 'Login',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<LoginBloc>(create: (context) => LoginBloc(),
                  child: LoginPage(),),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _inputTextField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    int? maxText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              height: 1.2,
              color: Colors.black,
            ),
          ),
        ),
        Input(
          keyboardType: keyboardType,
          maxText: maxText,
          controller: controller,
          onChanged: (text) {},
          textInputAction: TextInputAction.next,
          onSubmit: (_) => focusNode.requestFocus(),
          hint: hintText,
          prefixIconPath: 'assets/images/ic_lock.png',
        ),
      ],
    );
  }
}
