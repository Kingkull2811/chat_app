import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_room_event.dart';
import 'chat_room_state.dart';

class OnChattingBloc extends Bloc<OnChattingEvent, OnChattingState> {
  OnChattingBloc(BuildContext context) : super(OnChattingState()) {
    on((event, emit) async {
      //emit(state.copyWith(isLoading:  true));
    });
  }
}
