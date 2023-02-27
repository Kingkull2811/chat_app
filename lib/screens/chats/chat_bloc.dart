
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './chat_event.dart';
import './chat_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState>{
  ChatsBloc(BuildContext context): super(ChatsState()){
    on((event, emit) async{

    });
  }
}