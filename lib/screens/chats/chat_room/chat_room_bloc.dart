import 'package:chat_app/services/firebase_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/enum/api_error_result.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc(BuildContext context) : super(ChatRoomState()) {
    on((event, emit) async {
      if (event is GetMessage) {
        emit(state.copyWith(isLoading: true));
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final listMessage =
              await FirebaseService().getListMessage(event.docId);

          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
            listMessage: listMessage,
          ));
        }
      }
      if (event is AddMessage) {}
    });
  }
}
