// import 'dart:io';
//
// import 'package:cached_video_player/cached_video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wakelock/wakelock.dart';
//
// import '../../utilities/utils.dart';
// import '../../widgets/video_frame/play_button.dart';
// import '../../widgets/video_frame/play_button_bloc.dart';
// import '../../widgets/video_frame/video_frame_bloc.dart';
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String? videoUrl;
//   final Duration? position;
//   final VideoFrameState? currentState;
//
//   const VideoPlayerScreen({
//     Key? key,
//     this.videoUrl,
//     this.position,
//     this.currentState,
//   }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _VideoPlayerState();
// }
//
// class _VideoPlayerState extends State<VideoPlayerScreen> {
//   CachedVideoPlayerController? _controller;
//
//   late PlayButtonBloc _playButtonBloc;
//   late VideoFrameBloc _videoFrameBloc;
//
//   bool isOnline = true;
//
//   _listener() {
//     final bool? isPlaying = _controller?.value.isPlaying;
//     if (_controller?.value.position != null) {
//       if (isPlaying == true) {
//         _videoFrameBloc.add(Play((_controller?.value.position)!));
//         _playButtonBloc.add(HidePauseIcon());
//       } else {
//         _videoFrameBloc.add(Pause((_controller?.value.position)!));
//         _playButtonBloc.add(ShowPlayIcon());
//       }
//     }
//   }
//
//   void _setup() {
//     _controller?.seekTo(widget.position ?? const Duration(milliseconds: 0));
//     Future.delayed(const Duration(milliseconds: 100), () {
//       setState(() {});
//       if (widget.currentState is Playing && widget.position != null) {
//         _videoFrameBloc.add(Play(widget.position!));
//         _playButtonBloc.add(HidePauseIcon());
//         _controller?.play();
//       } else {
//         _videoFrameBloc.add(Pause(widget.position!));
//         _playButtonBloc.add(ShowPlayIcon());
//         _controller?.pause();
//       }
//     });
//   }
//
//   CachedVideoPlayerController _getLocalController() =>
//       CachedVideoPlayerController.file(File(widget.videoUrl ?? ''))
//         ..addListener(_listener)
//         ..initialize().then((_) {
//           _setup();
//         });
//
//   CachedVideoPlayerController _getNetworkController() =>
//       CachedVideoPlayerController.network(widget.videoUrl ?? '')
//         ..addListener(_listener)
//         ..initialize().then((_) {
//           _setup();
//         });
//
//   @override
//   void initState() {
//     Wakelock.enable();
//     _videoFrameBloc = BlocProvider.of<VideoFrameBloc>(context);
//     _playButtonBloc = PlayButtonBloc();
//     _controller = isOnline ? _getNetworkController() : _getLocalController();
//
//     super.initState();
//
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
//   }
//
//   @override
//   void dispose() {
//     _controller?.removeListener(_listener);
//     _controller?.pause();
//     _controller?.dispose();
//     _videoFrameBloc.close();
//     _playButtonBloc.close();
//     Wakelock.disable();
//
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VideoFrameBloc, VideoFrameState>(
//       builder: (context, state) {
//         final paddingTop = MediaQuery.of(context).padding.top;
//         return Scaffold(
//           // Use a FutureBuilder to display a loading spinner while waiting for the
//           // VideoPlayerController to finish initializing.
//           body: Container(
//             color: const Color.fromARGB(255, 26, 26, 26),
//             child: Stack(
//               alignment: AlignmentDirectional.bottomCenter,
//               children: <Widget>[
//                 Stack(
//                   alignment: AlignmentDirectional.center,
//                   children: <Widget>[
//                     Stack(
//                       children: <Widget>[
//                         Center(
//                           child: AspectRatio(
//                             aspectRatio: _controller?.value.aspectRatio ?? 0.0,
//                             // Use the VideoPlayer widget to display the video.
//                             child: GestureDetector(
//                                 onTap: () {
//                                   if (_controller?.value.isPlaying == true) {
//                                     _playButtonBloc.add(ShowPauseIcon());
//                                   } else {
//                                     if (_playButtonBloc.state
//                                         is FadeInPlayButton) {
//                                       _playButtonBloc.add(HidePlayIcon());
//                                     } else {
//                                       _playButtonBloc.add(ShowPlayIcon());
//                                     }
//                                   }
//                                 },
//                                 child: (_controller != null)
//                                     ? CachedVideoPlayer(_controller!)
//                                     : const SizedBox.shrink()),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(
//                                   12, paddingTop + 12, 12, 12),
//                               child: GestureDetector(
//                                   onTap: () => Navigator.pop(
//                                       context, _controller?.value),
//                                   child: Image.asset(
//                                       'images/ic_close_white.png',
//                                       width: 34,
//                                       height: 34)),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                     BlocProvider<PlayButtonBloc>(
//                       create: (BuildContext context) => _playButtonBloc,
//                       child: PlayButton(
//                         onPress: () {
//                           if (_controller?.value.isPlaying == true) {
//                             _controller?.pause();
//                             _playButtonBloc.add(ShowPlayIcon());
//                           } else {
//                             if (_controller?.value.position ==
//                                 _controller?.value.duration) {
//                               _controller
//                                   ?.seekTo(const Duration(milliseconds: 0));
//                             }
//                             _controller?.play();
//                             _playButtonBloc.add(HidePauseIcon());
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 _handleControl(state)
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   _handleControl(VideoFrameState state) {
//     if (_controller != null) {
//       return Container(
//         padding: MediaQuery.of(context).padding,
//         color: const Color.fromARGB(50, 0, 0, 0),
//         child: Row(
//           children: <Widget>[
//             SizedBox(
//               width: 40,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5, right: 5),
//                 child: Text(
//                   printDuration(state.position),
//                   style: const TextStyle(
//                     fontSize: 10,
//                     color: Colors.white,
//                     shadows: <Shadow>[
//                       Shadow(
//                         offset: Offset(0.0, 0.0),
//                         blurRadius: 3.0,
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: VideoProgressIndicator(
//                 _controller!,
//                 allowScrubbing: true,
//                 padding: const EdgeInsets.only(top: 10, bottom: 10),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context, _controller?.value);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
//                 child: Icon(
//                   Icons.crop_free,
//                   color: Theme.of(context).primaryColor,
//                   size: 20,
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     }
//   }
// }
