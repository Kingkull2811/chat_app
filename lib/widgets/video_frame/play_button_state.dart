part of 'play_button_bloc.dart';

abstract class PlayButtonState extends Equatable {
  const PlayButtonState();

  @override
  List<Object> get props => [];
}

class FadeInPlayButton extends PlayButtonState {}

class FadeInPauseButton extends PlayButtonState {}

class FadeOutPlayButton extends PlayButtonState {}

class FadeOutPauseButton extends PlayButtonState {}
