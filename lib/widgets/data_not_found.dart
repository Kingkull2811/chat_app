import 'package:flutter/material.dart';

class DataNotFoundPage extends StatelessWidget {
  final String title;

  const DataNotFoundPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/image_wrong.png',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
