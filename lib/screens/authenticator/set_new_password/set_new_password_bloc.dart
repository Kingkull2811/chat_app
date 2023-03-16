import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_event.dart';
import 'package:chat_app/screens/authenticator/set_new_password/set_new_password_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetNewPasswordBloc extends Bloc<SetNewPasswordEvent, SetNewPasswordState>{
  final BuildContext context;

  SetNewPasswordBloc({required this.context,}): super(SetNewPasswordState()){
    on((event, emit) async{
      if(event is Validate){emit(state.copyWith(),);}
      if(event is DisplayLoading){emit(state.copyWith(),);}
      if(event is OnSuccess){emit(state.copyWith(),);}
      if(event is OnFailure){emit(state.copyWith(),);}
    });
  }

}