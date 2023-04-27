import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../theme.dart';

class AudioCallPage extends StatefulWidget {
  final String imageUrl;
  final String name;

  const AudioCallPage({
    Key? key,
    required this.imageUrl,
    required this.name,
  }) : super(key: key);

  @override
  State<AudioCallPage> createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  bool isMute = false;
  bool isOpenMic = true;
  bool isOnCalling = true;

  late Timer _timer;
  Duration duration = const Duration();
  String countTime = '0:00:00';

  setTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;

      duration = Duration(seconds: seconds);
      String hh = duration.inHours.toString();
      String mm = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      String ss = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

      countTime = "$hh:$mm:$ss";
    });
  }

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setTime());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.withOpacity(0.45),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(75),
                        // image: DecorationImage(
                        //   image: NetworkImage(
                        //     widget.imageUrl,
                        //   ),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: CircleAvatar(
                        radius: 75,
                        child: Image.asset(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      isOnCalling ? countTime : 'connecting ...',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SizedBox(
                width: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMute = !isMute;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xffEAEAEA)),
                        child: Icon(
                          isMute
                              ? Icons.volume_off_outlined
                              : Icons.volume_up_outlined,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isOpenMic = !isOpenMic;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xffEAEAEA)),
                        child: Icon(
                          // isOpenMic? CupertinoIcons.mic : CupertinoIcons.mic_off,
                          isOpenMic
                              ? Icons.mic_none_outlined
                              : Icons.mic_off_outlined,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //todo: print('end audio call. time_call: $countTime');
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors.red700,
                        ),
                        child: const Icon(
                          Icons.call_end_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
