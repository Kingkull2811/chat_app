import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password_bloc.dart';
import 'package:chat_app/screens/authenticator/forgot_password/forgot_password_event.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp_bloc.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/input_field.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final AuthRepository _authRepository = AuthRepository();

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
        if (state.apiError == ApiError.noInternetConnection) {
          showCupertinoMessageDialog(
            context,
            'error',
            content: 'no_internet_connection',
          );
        }
      },
      builder: (BuildContext context, state) {
        Widget body = const SizedBox.shrink();
        if (state.isLoading) {
          body = const Scaffold(body: AnimationLoading());
        } else {
          body = _body(state);
        }
        return body;
      },
    );
  }

  Widget _body(ForgotPasswordState state) {
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
            color: Colors.black,
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
                    _inputField(),
                  ],
                ),
              ),
            ),
            _buttonSendCode(state),
          ],
        ),
      ),
    );
  }

  Widget _inputField() {
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
          prefixIcon: Icons.mail_outline,
        ),
      ),
    );
  }

  Widget _buttonSendCode(ForgotPasswordState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: PrimaryButton(
        text: "Send me Code",
        isDisable: _emailController.text.isEmpty,
        onTap: _emailController.text.isEmpty
            ? null
            : () async {
                ConnectivityResult connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none && mounted) {
                  showMessageNoInternetDialog(context);
                } else {
                  _forgotPasswordBloc.add(DisplayLoading());
                  final response = await _authRepository.forgotPassword(
                    email: _emailController.text.trim(),
                    // email: 'truong3@gmail.com',
                  );

                  print(response);
                  if (response.isSuccess && mounted) {
                    _forgotPasswordBloc.add(OnSuccess());
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
                  } else {
                    // setState(() {
                    //   state.isLoading = false;
                    // });
                    _forgotPasswordBloc.add(OnFailure(
                      errorMessage: response.errors?.first.errorMessage,
                    ));
                    showCupertinoMessageDialog(
                      context,
                      response.errors?.first.errorMessage,
                    );
                  }
                }
              },
      ),
    );
  }
}
