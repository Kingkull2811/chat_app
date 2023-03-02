import 'package:chat_app/screens/chats/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }

  void reloadPage() {
    //BlocProvider.of<ChatsPageBloc>(context).add();
  }
}
