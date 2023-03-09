import 'package:chat_app/screens/authenticator/verify_otp/verify_otp.dart';
import 'package:flutter/material.dart';

import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? username;
  const ForgotPasswordPage({Key? key, this.username}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Image.asset('assets/images/ic_back.png'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height - 180,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/image_wrong.png',
                      width: 150,
                      height: 150,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Reset your password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text(
                        'Please enter your email. We will send a code to your email to reset your password.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _inputPhoneField(),
                  ],
                ),
              ),
              _buttonSendCode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 50, right: 16),
      child: SizedBox(
        height: 50,
        child: Input(
          keyboardType: TextInputType.phone,
          maxText: 10,
          controller: _emailController,
          onChanged: (text) {},
          textInputAction: TextInputAction.next,
          onSubmit: (_) => focusNode.requestFocus(),
          hint: 'Enter your email',
          //prefixIconPath: 'assets/images/ic_phone.png',
          prefixIcon: const Icon(
            Icons.mail_outline,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buttonSendCode() {
    return PrimaryButton(
      text: "Send me Code",
      isDisable: _emailController.text.isEmpty,
      onTap: _emailController.text.isEmpty
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyOTP(
                    email: _emailController.text.trim(),
                  ),
                ),
              );
            },
    );
  }
}
