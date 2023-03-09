
import 'package:flutter/material.dart';

import '../../../widgets/custom_app_bar_chat.dart';
import '../chat.dart';

class OnChattingPage extends StatefulWidget {
  final CustomListItem item;

  const OnChattingPage({Key? key, required this.item}) : super(key: key);

  @override
  State<OnChattingPage> createState() => OnChattingPageState();
}

class OnChattingPageState extends State<OnChattingPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBarChat(
        title: widget.item.title,
        image: widget.item.imageUrl,
      ),
      body: Container(
        color: Colors.blue,
      )
    );
  }

  void reloadPage() {
    //BlocProvider.of<ChatsPageBloc>(context).add();
  }
}
