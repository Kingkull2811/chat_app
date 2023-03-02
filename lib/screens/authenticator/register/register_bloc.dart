import 'package:chat_app/screens/authenticator/register/register_event.dart';
import 'package:chat_app/screens/authenticator/register/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  final BuildContext context;

  RegisterBloc(this.context): super(RegisterState()){
    on((event, emit) async{

    });
  }
}