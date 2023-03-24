import 'package:chat_app/screens/transcript/add_transcript/add_transcript.dart';
import 'package:flutter/material.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({Key? key}) : super(key: key);

  @override
  State<TranscriptPage> createState() => TranscriptPageState();
}

class TranscriptPageState extends State<TranscriptPage> {
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transcript',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          isAdmin
              ? IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTranscriptsPage(),
                ),
              );
            },
            icon: Icon(
              Icons.edit_note,
              size: 30,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Container(),
      ),
    );
  }
}