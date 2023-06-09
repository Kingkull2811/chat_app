import 'package:chat_app/services/firebase_services.dart';
import 'package:flutter/material.dart';

import '../network/model/call_model.dart';
import '../screens/chats/call/waiting_call.dart';
import 'enum/call_type.dart';

class CallUtils {
  static dialVideo({
    context,
    bool isFromChat = false,
    required String callerId,
    callerName,
    callerPic,
    callerFCMToken,
    required String receiverId,
    receiverName,
    receiverPic,
    receiverFCMToken,
    required CallType callType,
  }) async {
    CallModel call = CallModel(
      callerId: callerId,
      callerName: callerName,
      callerPic: callerPic,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPic: receiverPic,
      channelName: callType.name,
    );

    bool callMade = await FirebaseService().makeVideoCall(
      call: call,
      receiverToken: receiverFCMToken,
    );

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => VoiceCallPage(call: call),
          builder: (context) => WaitingCallPage(
            call: call,
            isFromChat: isFromChat,
          ),
        ),
      );
    }
  }

  static dialVoice({
    context,
    bool isFromChat = false,
    required String callerId,
    callerName,
    callerPic,
    callerFCMToken,
    required String receiverId,
    receiverName,
    receiverPic,
    receiverFCMToken,
    required CallType callType,
  }) async {
    CallModel call = CallModel(
      callerId: callerId,
      callerName: callerName,
      callerPic: callerPic,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPic: receiverPic,
      channelName: callType.name,
      isAcceptCall: true,
    );

    bool callMade = await FirebaseService().makeVoiceCall(
      call: call,
      receiverToken: receiverFCMToken,
    );

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => VoiceCallPage(call: call),
          builder: (context) => WaitingCallPage(
            call: call,
            isFromChat: isFromChat,
          ),
        ),
      );
    }
  }
}
