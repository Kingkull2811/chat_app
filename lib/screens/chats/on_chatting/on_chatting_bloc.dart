import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'on_chatting_event.dart';
import 'on_chatting_state.dart';

class OnChattingBloc extends Bloc<OnChattingEvent, OnChattingState>{
  OnChattingBloc(BuildContext context): super(OnChattingState()){
    on((event, emit) async{
      //emit(state.copyWith(isLoading:  true));
    });
  }
}