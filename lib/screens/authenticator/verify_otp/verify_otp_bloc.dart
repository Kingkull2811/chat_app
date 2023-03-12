import 'package:chat_app/screens/authenticator/verify_otp/verify_otp_event.dart';
import 'package:chat_app/screens/authenticator/verify_otp/verify_otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState>{
  final BuildContext context;

  VerifyOtpBloc(this.context): super(VerifyOtpState()){
    on((event, emit) async{

    });
  }

}