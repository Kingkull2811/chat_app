part of 'video_frame_bloc.dart';

abstract class VideoFrameState extends Equatable {
  final Duration position;

  const VideoFrameState(this.position);

  @override
  List<Object> get props => [position];
}

class InitialState extends VideoFrameState {
  const InitialState(Duration position) : super(position);
}

class Pausing extends VideoFrameState {
  const Pausing(Duration position) : super(position);
}

class Playing extends VideoFrameState {
  const Playing(Duration position) : super(position);
}
