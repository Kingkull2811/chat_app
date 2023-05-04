import 'dart:io';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:chat_app/widgets/video_frame/play_button.dart';
import 'package:chat_app/widgets/video_frame/play_button_bloc.dart';
import 'package:chat_app/widgets/video_frame/video_frame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/video_player/video_player.dart';
import '../../utilities/utils.dart';

class VideoFrame extends StatefulWidget {
  final String? videoUrl;
  final bool isOnline;
  final VideoFrameWidgetState? videoFrameState;

  const VideoFrame({
    Key? key,
    this.videoUrl,
    this.isOnline = false,
    required this.videoFrameState,
  }) : super(key: key);

  @override
  // State<StatefulWidget> createState() => videoFrameState as VideoFrameWidgetState;
  State<StatefulWidget> createState() => VideoFrameWidgetState();
}

class VideoFrameWidgetState extends State<VideoFrame> {
  late CachedVideoPlayerController _controller;

  PlayButtonBloc? _playButtonBloc;
  VideoFrameBloc? _videoFrameBloc;

  _listener() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {});
    });
    final bool isPlaying = _controller.value.isPlaying;
    if (isPlaying) {
      _videoFrameBloc?.add(Play(_controller.value.position));
      _playButtonBloc?.add(HidePauseIcon());
    } else {
      _videoFrameBloc?.add(Pause(_controller.value.position));
      _playButtonBloc?.add(ShowPlayIcon());
    }
  }

  CachedVideoPlayerController _getNetworkController() =>
      CachedVideoPlayerController.network(widget.videoUrl ?? '')
        ..addListener(_listener)
        ..initialize().then((_) {
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {});
          });
        });

  CachedVideoPlayerController _getLocalController() =>
      CachedVideoPlayerController.file(File(widget.videoUrl ?? ''))
        ..addListener(_listener)
        ..initialize().then((_) {
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {});
          });
        });

  @override
  void initState() {
    super.initState();
    _videoFrameBloc = BlocProvider.of<VideoFrameBloc>(context);
    _playButtonBloc = PlayButtonBloc();
    _controller =
        widget.isOnline ? _getNetworkController() : _getLocalController();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.pause();
    _controller.dispose();
    _videoFrameBloc?.close();
    _playButtonBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoFrameBloc, VideoFrameState>(
        builder: (context, state) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      // Use the VideoPlayer widget to display the video.
                      child: GestureDetector(
                          onTap: () {
                            if (_controller.value.isPlaying) {
                              _playButtonBloc?.add(ShowPauseIcon());
                            } else {
                              if (_playButtonBloc?.state is FadeInPlayButton) {
                                _playButtonBloc?.add(HidePlayIcon());
                              } else {
                                _playButtonBloc?.add(ShowPlayIcon());
                              }
                            }
                          },
                          child: _handleState(state)),
                    ),
                  ),
                ],
              ),
              BlocProvider<PlayButtonBloc>(
                create: (BuildContext context) => PlayButtonBloc(),
                child: PlayButton(onPress: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                    _playButtonBloc?.add(ShowPlayIcon());
                  } else {
                    if (_controller.value.position ==
                        _controller.value.duration) {
                      _controller.seekTo(const Duration(milliseconds: 0));
                    }
                    _controller.play();
                    _playButtonBloc?.add(HidePauseIcon());
                  }
                }),
              ),
            ],
          ),
          _handleControl(state)
        ],
      );
    });
  }

  Widget _handleState(VideoFrameState state) {
    if (state is InitialState) {
      return Opacity(
        opacity: 0,
        child: CachedVideoPlayer(_controller),
      );
    }
    return CachedVideoPlayer(_controller);
  }

  _handleControl(VideoFrameState state) {
    return Container(
      color: const Color.fromARGB(50, 0, 0, 0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 40,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(printDuration(state.position),
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 0.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ])),
            ),
          ),
          Expanded(
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final isPlaying = _controller.value.isPlaying;
              _controller.pause();
              final CachedVideoPlayerValue result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => VideoFrameBloc(),
                    child: VideoPlayerScreen(
                      videoUrl: widget.videoUrl,
                      position: _controller.value.position,
                      currentState: isPlaying
                          ? Playing(_controller.value.position)
                          : Pausing(_controller.value.position),
                    ),
                  ),
                ),
              );
              _controller.seekTo(result.position).then((value) {
                if (result.isPlaying) {
                  _controller.play();
                  _playButtonBloc?.add(HidePauseIcon());
                } else {
                  _controller.pause();
                  _playButtonBloc?.add(ShowPlayIcon());
                }
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.crop_free, color: Colors.white70, size: 20),
            ),
          )
        ],
      ),
    );
  }

  void pauseVideo() {
    _controller.pause();
  }
}
