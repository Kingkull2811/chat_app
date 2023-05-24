import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:equatable/equatable.dart';

abstract class AudioCallState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AudioCallInitial extends AudioCallState {
  @override
  List<Object?> get props => ['VoiceCallerInitial'];
}

class JoinChannelSuccess extends AudioCallState {
  final String channel;
  final int uid;
  final int elapsed;

  JoinChannelSuccess({
    required this.channel,
    required this.uid,
    required this.elapsed,
  });

  @override
  List<Object?> get props => [channel, uid, elapsed];
}

class LeaveChannel extends AudioCallState {
  final RtcStats stats;

  LeaveChannel({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class UserMuteAudio extends AudioCallState {
  final bool isMute;

  UserMuteAudio({required this.isMute});

  @override
  List<Object?> get props => [isMute];
}

class RemoteUserJoined extends AudioCallState {
  final int uid;
  final int elapsed;

  RemoteUserJoined({
    required this.uid,
    required this.elapsed,
  });

  @override
  List<Object?> get props => [uid, elapsed];
}
