import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/screens/main/tab/tab_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider<TabBloc>(
                          create: (BuildContext context) => TabBloc(),
                          child: MainApp(navFromStart: true),
                        )));
          },
          child: const Center(
            child: Text(
              'Home',
              style: TextStyle(fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }
}
