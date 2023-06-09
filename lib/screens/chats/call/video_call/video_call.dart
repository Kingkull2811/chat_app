// import 'package:agora_uikit/agora_uikit.dart';
import 'package:chat_app/network/model/call_model.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../services/firebase_services.dart';
import '../../../../services/zego_config.dart';

class VideoCallPage extends StatefulWidget {
  final CallModel call;
  final bool isFromWaiting;

  const VideoCallPage({
    Key? key,
    required this.call,
    this.isFromWaiting = false,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  // AgoraClient? _client;

  // bool isMute = false;
  // bool isOpenMic = true;
  // bool isOnCalling = true;
  //
  // late Timer _timer;
  // Duration duration = const Duration();
  // String countTime = '0:00:00';
  //
  // setTime() {
  //   setState(() {
  //     final seconds = duration.inSeconds + 1;
  //
  //     duration = Duration(seconds: seconds);
  //     String hh = duration.inHours.toString();
  //     String mm = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  //     String ss = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  //
  //     countTime = "$hh:$mm:$ss";
  //   });
  // }
  //
  // void initAgora() async {
  //   // await _client!.initialize();
  // }

  @override
  void initState() {
    // _timer = Timer.periodic(const Duration(seconds: 1), (_) => setTime());
    super.initState();
    // // _client = AgoraClient(
    // //   agoraConnectionData: AgoraConnectionData(
    // //     appId: AgoraConfig.appId,
    // //     channelName: AgoraConfig.channelName,
    // //     tokenUrl: ApiPath.agoraServerDomain,
    // //   ),
    // // );
    // initAgora();
  }

  @override
  void dispose() {
    // _timer.cancel();
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
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              ..avatarBuilder = (context, Size size, ZegoUIKitUser? user,
                  Map<String, dynamic> map) {
                return user != null
                    ? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              isMe
                                  ? (widget.call.callerPic ?? '')
                                  : (widget.call.receiverPic ?? ''),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox();
              }
              ..onOnlySelfInRoom = (context) {
                // Navigator.pop(context);
                Navigator.pop(context);
              }
              ..turnOnCameraWhenJoining = true
              ..turnOnMicrophoneWhenJoining = true
              ..useSpeakerWhenJoining = false
              ..durationConfig.isVisible = true
              ..layout = ZegoLayout.pictureInPicture(
                isSmallViewDraggable: true,
                switchLargeOrSmallViewByClick: true,
              )
              ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
                foregroundBuilder: (BuildContext context, Size size,
                    ZegoUIKitUser? user, Map extraInfo) {
                  return user != null
                      ? Positioned(
                          bottom: 5,
                          left: 5,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  isMe
                                      ? (widget.call.receiverPic ?? '')
                                      : (widget.call.callerPic ?? ''),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
                showAvatarInAudioMode: true,
                showSoundWavesInAudioMode: true,
              )
              ..onHangUp = () {
                FirebaseService().endCall(call: widget.call);
                Navigator.pop(context);
                if (widget.isFromWaiting) Navigator.pop(context);
              }
              ..onOnlySelfInRoom = (context) {
                Navigator.of(context).pop(true);
              }
              ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
                showAvatarInAudioMode: false,
                showSoundWavesInAudioMode: true,
              ),
          ),
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
