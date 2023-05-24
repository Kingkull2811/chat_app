import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:equatable/equatable.dart';

abstract class AudioCallEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends AudioCallEvent {}

class JoinChannelEvent extends AudioCallEvent {}

class LeaveChannelEvent extends AudioCallEvent {
  final RtcStats stats;

  LeaveChannelEvent({required this.stats});
}

class SwitchMicrophoneEvent extends AudioCallEvent {}

class SwitchSpeakerphoneEvent extends AudioCallEvent {}

class UserMuteAudioEvent extends AudioCallEvent {
  final bool isMute;

  UserMuteAudioEvent({this.isMute = false});
}

class JoinChannelSuccessEvent extends AudioCallEvent {
  final String channel;
  final int uid;
  final int elapsed;

  JoinChannelSuccessEvent({
    required this.channel,
    required this.uid,
    required this.elapsed,
  });
}

class RemoteUserJoinedEvent extends AudioCallEvent {
  final int uid;
  final int elapsed;

  RemoteUserJoinedEvent({required this.uid, required this.elapsed});
}
