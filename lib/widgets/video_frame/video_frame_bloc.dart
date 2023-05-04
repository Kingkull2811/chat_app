import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'video_frame_event.dart';
part 'video_frame_state.dart';

class VideoFrameBloc extends Bloc<VideoFrameEvent, VideoFrameState> {
  VideoFrameBloc() : super(const InitialState(Duration(seconds: 0))) {
    on((event, emit) {
      if (event is Play) {
        emit(Playing(event.position));
      }

      if (event is Pause) {
        emit(Pausing(event.position));
      }

      if (event is EnterFullScreen) {
        emit(Pausing(event.position));
      }

      if (event is ExitFullScreen) {
        if (event.isPlaying) {
          emit(Playing(event.position));
        } else {
          emit(Pausing(event.position));
        }
      }

      if (event is ShowControl) {
        if (event.isPlaying) {
          emit(Playing(event.position));
        } else {
          emit(Pausing(event.position));
        }
      }
    });
  }
}
