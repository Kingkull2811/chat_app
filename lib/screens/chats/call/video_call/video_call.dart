import 'dart:async';

import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

class VideoCallPage extends StatefulWidget {
  final String imageUrl;
  final String name;

  const VideoCallPage({Key? key, required this.imageUrl, required this.name})
      : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
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
              padding: const EdgeInsets.only(left: 16, top: 0, right: 16),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index == 5) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
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
                          // child: CircleAvatar(
                          //   radius: 75,
                          //   child: Image.asset(
                          //     widget.imageUrl,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          child: const Center(
                            child: Text(
                              '+3',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.only(top: 10.0),
                        //   child: Text(
                        //     'Other People',
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 20,
                        //         color: Colors.white),
                        //   ),
                        // ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Container(
                          height: 100,
                          width: 100,
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
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        isOnCalling ? countTime : 'connecting ...',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(
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
                              //todo::print('end audio call. time_call: $countTime');
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
