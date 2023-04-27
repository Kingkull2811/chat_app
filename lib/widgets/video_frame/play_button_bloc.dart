import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'play_button_event.dart';
part 'play_button_state.dart';

class PlayButtonBloc extends Bloc<PlayButtonEvent, PlayButtonState> {
  PlayButtonBloc() : super(FadeInPlayButton()) {
    on((event, emit) async {
      if (event is ShowPlayIcon) {
        emit(FadeInPlayButton());
      }
      if (event is ShowPauseIcon) {
        emit(FadeInPauseButton());
      }
      if (event is HidePlayIcon) {
        emit(FadeOutPlayButton());
      }
      if (event is HidePauseIcon) {
        emit(FadeOutPauseButton());
      }
    });
  }
}
