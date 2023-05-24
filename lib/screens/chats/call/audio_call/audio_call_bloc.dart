import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

import 'audio_call_event.dart';
import 'audio_call_state.dart';

class AudioCallBloc extends Bloc<AudioCallEvent, AudioCallState> {
  AudioCallBloc() : super(AudioCallInitial()) {
    on<AudioCallEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

class VoiceCallerBloc extends Bloc<AudioCallEvent, AudioCallState> {
  late final RtcEngine _engine;
  String channelId = '';
  bool isJoined = false;
  bool openMicrophone = true;
  bool enableSpeakerphone = true;
  bool playEffect = false;
  bool enableInEarMonitoring = false;
  double recordingVolume = 0;
  double playbackVolume = 0;
  double inEarMonitoringVolume = 0;
  bool isRemoteJoined = false;
  bool isMicMute = false;
  bool isSpeakerOpen = false;
  Stopwatch watch = Stopwatch();
  Timer? timer;
  String elapsedTime = '';
  bool isTimerRunning = false;

  late AudioPlayer player;

  VoiceCallerBloc() : super(AudioCallInitial()) {
    _initEngine();
    player = AudioPlayer();
  }

  void _initEngine() async {
    RtcEngineConfig config = RtcEngineConfig(AppConstants.agoraAppID);
    _engine = await RtcEngine.createWithConfig(config);
    _addListeners();
    await _engine.enableAudio();
  }

  void _addListeners() {
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          log('joinChannelSuccess $channel $uid $elapsed');

          playSound('assets/sound/caller.mp3');
          add(
            JoinChannelSuccessEvent(
              channel: channel,
              uid: uid,
              elapsed: elapsed,
            ),
          );
        },
        userJoined: (uid, elapsed) async {
          log('userJoined $uid');
          if (player.playing) {
            await player.stop();
          }
          isRemoteJoined = true;
          _setTimer();
          add(RemoteUserJoinedEvent(uid: uid, elapsed: elapsed));
        },
        leaveChannel: (stats) {
          watch.stop();
          log('leaveChannel ${stats.toJson()}');

          playSound("assets/sound/call_disconnected.mp3");

          isRemoteJoined = false;
          add(LeaveChannelEvent(stats: stats));
        },
        userOffline: (uid, userOfflineReason) {
          watch.stop();

          playSound('assets/sound/connectionLost.mp3');

          log('userOffline $userOfflineReason \n $uid');
        },
        activeSpeaker: (value) {
          log('activeSpeaker $value');
        },
        connectionBanned: () async {
          watch.stop();

          log('connectionBanned by agora server');
        },
        connectionInterrupted: () {
          watch.stop();

          playSound('assets/sound/connectionLost.mp3');
          log('connectionInterrupted');
        },
        connectionLost: () async {
          watch.stop();
          log('connectionLost');
          playSound('assets/sound/connectionLost.mp3');
        },
        microphoneEnabled: (value) {
          log('microphoneEnabled $value');
        },
        userMuteAudio: (uid, status) {
          log('userMuteAudio $uid, \n Status $state');
          add(UserMuteAudioEvent(isMute: status));
        },
        error: (errorCode) async {
          log('error $errorCode');

          playSound('assets/sound/connectionLost.mp3');
        },
        rejoinChannelSuccess: (channel, uid, elapsed) async {
          watch.start();
          log('joinChannelSuccess $channel $uid $elapsed');
          await player.stop();
          add(JoinChannelSuccessEvent(
            channel: channel,
            uid: uid,
            elapsed: elapsed,
          ));
        },
      ),
    );
  }

  Future<void> playSound(String fileName) async {
    if (player.playing) {
      await player.stop();
    }
    await player.setAsset(fileName);
    player.play();
  }

  Future<void> joinChannel() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await Permission.microphone.request();
      }
      //!token, channelName optionalInfo optionalUid,
      await _engine
          .joinChannel(AppConstants.agoraToken, 'kull_chat', null, 0)
          .catchError((onError) {
        print('error ${onError.toString()}');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> leaveChannel() async {
    try {
      await _engine.leaveChannel();
      await _engine.destroy();
    } catch (e) {
      log('Error $e');
    }
  }

  void switchMicrophone() {
    isMicMute = !isMicMute;
    _engine.enableLocalAudio(!isMicMute).then((value) {}).catchError((err) {
      log('enableLocalAudio $err');
    });
  }

  void switchSpeakerphone() {
    isSpeakerOpen = !isSpeakerOpen;
    try {
      _engine.setEnableSpeakerphone(isSpeakerOpen).then((value) {
        _engine.setInEarMonitoringVolume(400);
      }).catchError((err) {
        log('setEnableSpeakerphone $err');
      });
    } catch (e) {
      log('Error $e');
    }
  }

  Future<void> updateTime(Timer? timer) async {
    if (watch.isRunning) {
      elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      log('elapsedTime $elapsedTime');
    }
  }

  String transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$hoursStr:$minutesStr:$secondsStr";
  }

  void _setTimer() {
    watch.start();
    isTimerRunning = true;
    timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
    updateTime(timer);
  }

  @override
  Stream<AudioCallState> mapEventToState(AudioCallEvent event) async* {
    if (event is JoinChannelEvent) {
      yield* _mapJoinChannelEventToState();
    } else if (event is LeaveChannelEvent) {
      yield* _mapLeaveChannelEventToState();
    } else if (event is SwitchMicrophoneEvent) {
      yield* _mapSwitchMicrophoneEventToState();
    } else if (event is SwitchSpeakerphoneEvent) {
      yield* _mapSwitchSpeakerphoneEventToState();
    } else if (event is UserMuteAudioEvent) {
      yield* _mapUserMuteAudioEventToState(event);
    } else if (event is JoinChannelSuccessEvent) {
      yield* _mapJoinChannelSuccessEventToState(event);
    } else if (event is RemoteUserJoinedEvent) {
      yield* _mapRemoteUserJoinedEventToState(event);
    }
    // Add more event mappings as needed.
  }

  Stream<AudioCallState> _mapJoinChannelEventToState() async* {
    // Implement join channel logic
  }

  Stream<AudioCallState> _mapLeaveChannelEventToState() async* {
    // Implement leave channel logic
  }

  Stream<AudioCallState> _mapSwitchMicrophoneEventToState() async* {
    // Implement switch microphone logic
  }

  Stream<AudioCallState> _mapSwitchSpeakerphoneEventToState() async* {
    // Implement switch speakerphone logic
  }

  Stream<AudioCallState> _mapUserMuteAudioEventToState(
      UserMuteAudioEvent event) async* {
    // Implement user mute audio logic
  }

  Stream<AudioCallState> _mapJoinChannelSuccessEventToState(
      JoinChannelSuccessEvent event) async* {
    // Implement join channel success logic
  }

  Stream<AudioCallState> _mapRemoteUserJoinedEventToState(
      RemoteUserJoinedEvent event) async* {
    // Implement remote user joined logic
  }
}
