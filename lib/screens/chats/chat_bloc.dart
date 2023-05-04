import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './chat_event.dart';
import './chat_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc(BuildContext context) : super(ChatInitState()) {
    on((event, emit) async {
      if (event is ChatInit) {
        emit(LoadingState());
        emit(SuccessState());
        // final listUser = await FirebaseService().getAllProfile();
        //
        // if (isNullOrEmpty(listUser)) {
        //   log('all: $listUser');
        //   emit(SuccessState());
        // } else {
        //   emit(const ErrorState(isNoInternet: false));
        // }
      }
    });
  }
}
