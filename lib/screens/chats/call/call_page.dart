import 'dart:async';

import 'package:chat_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utilities/utils.dart';
import '../../../widgets/single_slider.dart';

class CallPage extends StatefulWidget {
  // final ReceivedAction receivedAction;

  const CallPage({Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  Timer? _timer;
  Duration _secondsElapsed = Duration.zero;

  void startCallingTimer() {
    const oneSec = Duration(seconds: 1);
    // NotificationUtils.cancelNotification(widget.receivedAction.id!);
    // AndroidForegroundService.stopForeground(widget.receivedAction.id!);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _secondsElapsed += oneSec;
        });
      },
    );
  }

  void finishCall() {
    // Vibration.vibrate(duration: 100);
    // NotificationUtils.cancelNotification(widget.receivedAction.id!);
    // AndroidForegroundService.stopForeground(widget.receivedAction.id!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    lockScreenPortrait();
    super.initState();
    // if (widget.receivedAction.buttonKeyPressed == 'ACCEPT') {
    //   startCallingTimer();
    // }
  }

  @override
  void dispose() {
    _timer?.cancel();
    unlockScreenPortrait();
    // NotificationUtils.cancelNotification(widget.receivedAction.id!);
    // AndroidForegroundService.stopForeground(widget.receivedAction.id!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    ThemeData themeData = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          Image.network(
            '',
            fit: BoxFit.cover,
          ),
          // Black Layer
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.black45),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Unknown',
                    // widget.receivedAction.payload?['username']?.replaceAll(r'\s+', r'\n') ?? 'Unknown',
                    maxLines: 4,
                    style: themeData.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _timer == null ? context.l10n.incomeCall : '${context.l10n.inProcessCall}: ${printDuration(_secondsElapsed)}',
                    style: themeData.textTheme.titleLarge?.copyWith(
                      color: Colors.white54,
                      fontSize: _timer == null ? 20 : 12,
                    ),
                  ),
                  const SizedBox(height: 50),
                  _timer == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.solidClock,
                                    color: Colors.white54,
                                  ),
                                  Text(
                                    context.l10n.remindMe,
                                    style: themeData.textTheme.titleLarge?.copyWith(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      height: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.solidEnvelope,
                                    color: Colors.white54,
                                  ),
                                  Text(
                                    context.l10n.message,
                                    style: themeData.textTheme.titleLarge?.copyWith(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      height: 2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _timer == null
                          ? [
                              RoundedButton(
                                press: finishCall,
                                color: Colors.red,
                                icon: const Icon(
                                  FontAwesomeIcons.phoneAlt,
                                  color: Colors.white,
                                ),
                              ),
                              SingleSliderToConfirm(
                                onConfirmation: () {
                                  // Vibration.vibrate(duration: 100);
                                  startCallingTimer();
                                },
                                width: mediaQueryData.size.width * 0.55,
                                backgroundColor: Colors.white60,
                                text: context.l10n.slideTalk,
                                stickToEnd: true,
                                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: mediaQueryData.size.width * 0.05,
                                    ),
                                sliderButtonContent: RoundedButton(
                                  press: () {},
                                  color: Colors.white,
                                  icon: const Icon(FontAwesomeIcons.phoneAlt, color: Colors.green),
                                ),
                              ),
                            ]
                          : [
                              RoundedButton(
                                press: () {},
                                color: Colors.white,
                                icon: const Icon(FontAwesomeIcons.microphone, color: Colors.black),
                              ),
                              RoundedButton(
                                press: finishCall,
                                color: Colors.red,
                                icon: const Icon(FontAwesomeIcons.phoneAlt, color: Colors.white),
                              ),
                              RoundedButton(
                                press: () {},
                                color: Colors.white,
                                icon: const Icon(FontAwesomeIcons.volumeUp, color: Colors.black),
                              ),
                            ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.size = 64,
    required this.icon,
    this.color = Colors.white,
    required this.press,
  }) : super(key: key);

  final double size;
  final Icon icon;
  final Color color;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.all(15 / 64 * size),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        ),
        onPressed: press,
        child: icon,
      ),
    );
  }
}
