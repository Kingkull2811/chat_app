import 'package:chat_app/network/model/call_model.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../services/firebase_services.dart';
import '../../../../services/zego_config.dart';

class VoiceCallPage extends StatefulWidget {
  final CallModel call;
  final bool isFromWaiting;

  const VoiceCallPage({
    Key? key,
    required this.call,
    this.isFromWaiting = false,
  }) : super(key: key);

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.call.callerId ==
            SharedPreferencesStorage().getUserId().toString()
        ? true
        : false;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: ZegoUIKitPrebuiltCall(
              appID: ZegoConfig.appID,
              appSign: ZegoConfig.appSign,
              userID: isMe
                  ? (widget.call.callerId ?? '')
                  : (widget.call.receiverId ?? ''),
              userName: isMe
                  ? (widget.call.callerName ?? '')
                  : (widget.call.receiverName ?? ''),
              callID: widget.call.channelName,
              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
                ..avatarBuilder = (context, Size size, ZegoUIKitUser? user,
                    Map<String, dynamic> map) {
                  return (user?.id == widget.call.callerId)
                      ? Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.call.callerPic ?? '',
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.call.receiverPic ?? '',
                              ),
                            ),
                          ),
                        );
                }
                ..onOnlySelfInRoom = (context) {
                  // Navigator.pop(context);
                  Navigator.pop(context);
                }
                ..turnOnCameraWhenJoining = false
                ..turnOnMicrophoneWhenJoining = true
                ..useSpeakerWhenJoining = false
                ..durationConfig.isVisible = true
                ..layout = ZegoLayout.pictureInPicture(
                  isSmallViewDraggable: true,
                  switchLargeOrSmallViewByClick: true,
                )
                ..onHangUp = () {
                  FirebaseService().endCall(call: widget.call);
                  Navigator.pop(context);
                  if (widget.isFromWaiting) Navigator.of(context).pop(true);
                }
                ..onOnlySelfInRoom = (context) {
                  Navigator.of(context).pop(true);
                }
                ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
                  //   foregroundBuilder: (BuildContext context, Size size,
                  //       ZegoUIKitUser? user, Map extraInfo) {
                  //     return (user != null && user.id == widget.call.callerId)
                  //         ? Positioned(
                  //             bottom: 5,
                  //             left: 5,
                  //             child: Container(
                  //               width: 30,
                  //               height: 30,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 image: DecorationImage(
                  //                   image:
                  //                       NetworkImage(widget.call.callerPic ?? ''),
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //         : Positioned(
                  //             bottom: 5,
                  //             left: 5,
                  //             child: Container(
                  //               width: 30,
                  //               height: 30,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 image: DecorationImage(
                  //                   image: NetworkImage(
                  //                     widget.call.receiverPic ?? '',
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //   },
                  showAvatarInAudioMode: true,
                  showSoundWavesInAudioMode: true,
                )),
        ),
        // body: _client == null
        //     ? const AnimationLoading()
        //     : SafeArea(
        //         child: Stack(
        //           children: [
        //             AgoraVideoViewer(client: _client!),
        //             AgoraVideoButtons(
        //               client: _client!,
        //               disconnectButtonChild: IconButton(
        //                 onPressed: () async {
        //                   await _client!.engine.leaveChannel();
        //                   // ref.read(callControllerProvider).endCall(
        //                   //   widget.call.callerId,
        //                   //   widget.call.receiverId,
        //                   //   context,
        //                   // );
        //                   await FirebaseService().endCall(call: widget.call);
        //                   Navigator.pop(this.context);
        //                 },
        //                 icon: const Icon(Icons.call_end),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
      ),
    );
  }
}
