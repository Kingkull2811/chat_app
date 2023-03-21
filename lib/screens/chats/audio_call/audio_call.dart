import 'package:flutter/material.dart';

class AudioCallPage extends StatefulWidget {
  const AudioCallPage({Key? key}) : super(key: key);

  @override
  State<AudioCallPage> createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
    );
  }
}
