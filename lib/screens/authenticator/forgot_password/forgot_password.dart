import 'package:chat_app/l10n/l10n.dart';
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

import '../../../utilities/app_constants.dart';
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

  late ForgotPasswordBloc _forgotPasswordBloc;
  final AuthRepository _authRepository = AuthRepository();

  final _formKey = GlobalKey<FormState>();

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
          showCupertinoMessageDialog(context, context.l10n.error, content: context.l10n.internal_server_error);
        }
        if (state.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
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
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.l10n.forgotPassword,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, size: 24, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          context.l10n.resetPassword,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          context.l10n.enterEmailToReset,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
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
      ),
    );
  }

  Widget _inputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Input(
        keyboardType: TextInputType.text,
        controller: _emailController,
        onChanged: (text) {
          setState(() {});
        },
        textInputAction: TextInputAction.done,
        onSubmit: (string) async {
          if (_formKey.currentState!.validate()) {
            await _onClickButton();
          }
        },
        labelText: context.l10n.email,
        // hint: 'Enter your email',
        prefixIcon: Icons.mail_outline,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return context.l10n.enter_email;
          } else if (!AppConstants.emailExp.hasMatch(value)) {
            return context.l10n.valid_email;
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonSendCode(ForgotPasswordState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: PrimaryButton(
        text: context.l10n.sendCode,
        isDisable: _emailController.text.isEmpty,
        onTap: _emailController.text.isEmpty
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  await _onClickButton();
                }
              },
      ),
    );
  }

  Future<void> _onClickButton() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none && mounted) {
      showMessageNoInternetDialog(context);
    } else {
      _forgotPasswordBloc.add(DisplayLoading());
      final response = await _authRepository.forgotPassword(email: _emailController.text.trim());

      if (response.isOK() && mounted) {
        _forgotPasswordBloc.add(OnSuccess());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<VerifyOtpBloc>(
              create: (context) => VerifyOtpBloc(context),
              child: VerifyOtp(email: _emailController.text.trim()),
            ),
          ),
        );
      } else {
        _forgotPasswordBloc.add(OnFailure(
          errorMessage: response.errors?.first.errorMessage,
        ));
        showCupertinoMessageDialog(
          context,
          response.errors?.first.errorMessage,
        );
      }
    }
  }
}
