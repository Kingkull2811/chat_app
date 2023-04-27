import 'package:chat_app/screens/main/main_app.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainApp(),
            ),
          );
        },
        child: Center(
          child: Image.asset(
            'assets/images/app_logo_light.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
