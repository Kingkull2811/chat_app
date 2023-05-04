part of 'video_frame_bloc.dart';

abstract class VideoFrameEvent extends Equatable {
  final Duration position;

  const VideoFrameEvent(this.position);

  @override
  List<Object> get props => [];
}

class Play extends VideoFrameEvent {
  const Play(Duration position) : super(position);

  @override
  List<Object> get props => [position];
}

class Pause extends VideoFrameEvent {
  const Pause(Duration position) : super(position);
}

class EnterFullScreen extends VideoFrameEvent {
  const EnterFullScreen(Duration position) : super(position);
}

class ExitFullScreen extends VideoFrameEvent {
  final bool isPlaying;

  const ExitFullScreen(Duration position, {this.isPlaying = false})
      : super(position);

  @override
  List<Object> get props => [isPlaying, position];
}

class Seek extends VideoFrameEvent {
  const Seek(Duration position) : super(position);
}

class ShowControl extends VideoFrameEvent {
  final bool isPlaying;

  const ShowControl(Duration position, {this.isPlaying = false})
      : super(position);

  @override
  List<Object> get props => [isPlaying, position];
}
