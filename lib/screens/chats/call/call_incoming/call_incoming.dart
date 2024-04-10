import 'package:chat_app/routes.dart';
import 'package:chat_app/screens/chats/call/audio_call/voice_call.dart';
import 'package:chat_app/screens/chats/call/video_call/video_call.dart';
import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../network/model/call_model.dart';
import '../../../../services/firebase_services.dart';
import '../../../../utilities/enum/call_type.dart';
import '../../../../widgets/app_image.dart';

class CallIncomingPage extends StatefulWidget {
  final Widget scaffold;

  const CallIncomingPage({Key? key, required this.scaffold}) : super(key: key);

  @override
  State<CallIncomingPage> createState() => _CallIncomingPageState();
}

class _CallIncomingPageState extends State<CallIncomingPage> {
  // final AudioPlayer player = AudioPlayer();
  //
  // Future<void> playSound(String fileName) async {
  //   if (player.playing) {
  //     await player.stop();
  //   }
  //   await player.setAsset(fileName);
  //   player.play();
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseService().callStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          final CallModel call = CallModel.fromJson(
            snapshot.data!.data() as Map<String, dynamic>,
          );
          if (!call.hasDialled) {
            // playSound('assets/sound/incoming_call.mp3');

            return Scaffold(
              backgroundColor: AppColors.primaryColor,
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Text(
                        'Incoming Call ...',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: AppImage(
                          isOnline: true,
                          localPathOrUrl: call.callerPic,
                          height: 150,
                          width: 150,
                          boxFit: BoxFit.cover,
                          errorWidget: Image.asset(
                            'assets/images/ic_account_circle.png',
                            fit: BoxFit.cover,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Text(
                        call.callerName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 48.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                FirebaseService().updateCallStatus(
                                  receiverDoc: 'call_id_${call.receiverId}',
                                  isAcceptCall: false,
                                );
                                Future.delayed(
                                  const Duration(seconds: 1),
                                  () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.chat,
                                    );
                                    // player.stop();
                                  },
                                );
                              },
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                              elevation: 4,
                              fillColor: Colors.white,
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.redAccent,
                                size: 36,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 48.0),
                            child: RawMaterialButton(
                              onPressed: () async {
                                await FirebaseService().updateCallStatus(
                                  receiverDoc: 'call_id_${call.receiverId}',
                                  isAcceptCall: true,
                                );
                                await Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                    builder: (context) => call.channelName ==
                                            CallType.audioCall.name
                                        ? VoiceCallPage(call: call)
                                        : VideoCallPage(call: call),
                                  ),
                                );
                              },
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                              elevation: 4,
                              fillColor: Colors.white,
                              child: const Icon(
                                Icons.call,
                                color: Colors.green,
                                size: 36,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return widget.scaffold;
      },
    );
  }
}
