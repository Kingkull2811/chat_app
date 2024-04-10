import 'package:chat_app/screens/chats/call/video_call/video_call.dart';
import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../network/model/call_model.dart';
import '../../../services/firebase_services.dart';
import '../../../utilities/enum/call_type.dart';
import '../../../widgets/app_image.dart';
import 'audio_call/voice_call.dart';

class WaitingCallPage extends StatefulWidget {
  final bool isFromChat;
  final CallModel call;

  const WaitingCallPage({
    Key? key,
    required this.call,
    this.isFromChat = false,
  }) : super(key: key);

  @override
  State<WaitingCallPage> createState() => _WaitingCallPageState();
}

class _WaitingCallPageState extends State<WaitingCallPage> {
  final AudioPlayer player = AudioPlayer();

  Future<void> playSound(String fileName) async {
    if (player.playing) {
      await player.stop();
    }
    await player.setAsset(fileName);
    player.play();
  }

  @override
  void initState() {
    super.initState();
    playSound('assets/sound/calling.mp3');
  }

  @override
  void dispose() {
    super.dispose();
    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseService().readStateCall(
        receiverDoc: 'call_id_${widget.call.receiverId}',
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          final CallModel call = CallModel.fromJson(
            snapshot.data!.data() as Map<String, dynamic>,
          );
          if (call.isAcceptCall == true) {
            Future.delayed(
              const Duration(seconds: 1),
              () async {
                player.stop();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        call.channelName == CallType.audioCall.name
                            ? VoiceCallPage(call: call)
                            : VideoCallPage(call: call),
                  ),
                );
                if (result != null) {
                  FirebaseService().endCall(call: call);
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      widget.isFromChat
                          ? Navigator.pop(context)
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainApp(
                                  currentTab: 0,
                                  toContact: true,
                                ),
                              ),
                            );
                    },
                  );
                } else {
                  FirebaseService().endCall(call: call);
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      widget.isFromChat
                          ? Navigator.pop(context)
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainApp(
                                  currentTab: 0,
                                  toContact: true,
                                ),
                              ),
                            );
                    },
                  );
                }
              },
            );
          } else if (call.isAcceptCall == false) {
            FirebaseService().endCall(call: call);
            Future.delayed(
              const Duration(seconds: 1),
              () {
                player.stop();
                Navigator.pop(context);
              },
            );
          }
        }
        // _isStop
        //     ? player.stop()
        //     : Future.delayed(const Duration(seconds: 30), () async {
        //         await playSound('assets/sound/signal.mp3');
        //         Future.delayed(const Duration(seconds: 5), () {
        //           player.stop();
        //           FirebaseService().endCall(call: widget.call);
        //           Navigator.pop(context);
        //         });
        //       });
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50.0, bottom: 50),
                  child: Text(
                    'Calling ...',
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: AppImage(
                      isOnline: true,
                      localPathOrUrl: widget.call.receiverPic,
                      errorWidget:
                          Image.asset('assets/images/ic_account_circle.png'),
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    widget.call.receiverName ?? '',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: RawMaterialButton(
                      onPressed: () async {
                        player.stop();

                        FirebaseService().endCall(call: widget.call);
                        Navigator.pop(context);
                      },
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      elevation: 4,
                      fillColor: Colors.redAccent,
                      child: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
