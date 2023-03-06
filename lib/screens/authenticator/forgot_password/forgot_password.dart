import 'package:flutter/material.dart';

import '../../../widgets/input_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? username;
  const ForgotPasswordPage({Key? key, this.username}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _inputPhoneController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _inputPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
                  'Please enter your phone number. We will send a code to your phone to reset your password.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _inputPhoneField()
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24, bottom: 6),
            child: Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 12,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Input(
              keyboardType: TextInputType.phone,
              maxText: 10,
              controller: _inputPhoneController,
              onChanged: (text) {
              },
              textInputAction: TextInputAction.next,
              onSubmit: (_) => focusNode.requestFocus(),
              hint: 'Enter your phone number',
              prefixIconPath: 'assets/images/ic_phone.png',
            ),
          ),
        ],
      ),
    );
  }
}
