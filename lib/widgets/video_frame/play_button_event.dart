part of 'play_button_bloc.dart';

abstract class PlayButtonEvent extends Equatable {
  const PlayButtonEvent();

  @override
  List<Object> get props => [];
}

class ShowPlayIcon extends PlayButtonEvent {}

class ShowPauseIcon extends PlayButtonEvent {}

class HidePlayIcon extends PlayButtonEvent {}

class HidePauseIcon extends PlayButtonEvent {}
