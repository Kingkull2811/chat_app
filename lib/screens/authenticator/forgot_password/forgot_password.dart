import 'package:chat_app/network/provider/forgot_password_provider.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password_bloc.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp_bloc.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/repository/forgot_password_repository.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';
import 'forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final focusNode = FocusNode();

  late ForgotPasswordBloc _forgotPasswordBloc;
  final _forgotPasswordRepository = ForgotPasswordRepository();

  @override
  void initState() {
    _forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _forgotPasswordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return _body();
      },
    );
  }

  Widget _body() {
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
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
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
            ),
            _buttonSendCode(),
          ],
        ),
      ),
    );
  }

  Widget _inputPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SizedBox(
        height: 50,
        child: Input(
          keyboardType: TextInputType.text,
          controller: _emailController,
          onChanged: (text) {
            setState(() {});
          },
          textInputAction: TextInputAction.next,
          onSubmit: (_) => focusNode.requestFocus(),
          hint: 'Enter your email',
          prefixIcon: const Icon(
            Icons.mail_outline,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buttonSendCode() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: PrimaryButton(
        text: "Send me Code",
        //isDisable: _emailController.text.isEmpty,
        onTap:
            //_emailController.text.isEmpty ? null :
            () async {
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none && mounted) {
            showMessageNoInternetDialog(context);
          } else {
            //_forgotPasswordBloc.add(DisplayLoading());
            // ForgotPasswordResult forgotPasswordResult =
            //     await _forgotPasswordRepository.forgotPassword(
            //         email: 'truong2@gmail.com'
            //         // email: _emailController.text.trim(),
            //         );
            final response = await ForgotPasswordProvider().forgotPassword(email: 'truong2@gmail.com');
            print('forgot: ${response.toString()}');
            if(mounted){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<VerifyOtpBloc>(
                    create: (context) => VerifyOtpBloc(context),
                    child: VerifyOtp(
                      email: _emailController.text.trim(),
                    ),
                  ),
                ),
              );
            }
          }
          // if (forgotPasswordResult.isSuccess && mounted) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => BlocProvider<VerifyOtpBloc>(
          //         create: (context) => VerifyOtpBloc(context),
          //         child: VerifyOtp(
          //           email: _emailController.text.trim(),
          //         ),
          //       ),
          //     ),
          //   );
          // } else {
          //   print(forgotPasswordResult.errors);
          //   // showCupertinoMessageDialog(
          //   //   context,
          //   //   forgotPasswordResult.errors,
          //   //   buttonLabel: 'OK',
          //   //   onCloseDialog: () {
          //   //     Navigator.pop(context);
          //   //   },
          //   //   barrierDismiss: false,
          //   // );
          // }
        },
      ),
    );
  }
}
