import 'package:chat_app/widgets/video_frame/play_button_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayButton extends StatefulWidget {
  final Function()? onPress;

  const PlayButton({super.key, this.onPress});

  @override
  State<StatefulWidget> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  PlayButtonBloc? _playButtonBloc;

  @override
  void initState() {
    _playButtonBloc = BlocProvider.of<PlayButtonBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _playButtonBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayButtonBloc, PlayButtonState>(
        builder: (context, buttonState) {
      return _handlePlayButton(buttonState);
    });
  }

  Widget _handlePlayButton(PlayButtonState buttonState) {
    Widget icon = Image.asset('images/btn_play.png');
    double opacity = 1.0;
    int duration = 300;

    if (buttonState is FadeInPlayButton) {
      icon = Image.asset('images/btn_play.png');
      opacity = 1.0;
    }

    if (buttonState is FadeInPauseButton) {
      icon = Image.asset('images/btn_pause.png');
      opacity = 1.0;
    }

    if (buttonState is FadeOutPlayButton) {
      icon = Image.asset('images/btn_play.png');
      opacity = 0.0;
    }

    if (buttonState is FadeOutPauseButton) {
      icon = Image.asset('images/btn_pause.png');
      opacity = 0.0;
      duration = 1000;
    }

    return AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: duration),
        child: SizedBox(
          width: 51,
          height: 51,
          child: RawMaterialButton(
            fillColor: Colors.white,
            shape: const CircleBorder(),
            elevation: 0.0,
            onPressed: widget.onPress,
            // Display the correct icon depending on the state of the player.
            child: SizedBox(
              width: 51,
              height: 51,
              child: icon,
            ),
          ),
        ));
  }
}
