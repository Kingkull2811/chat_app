import 'package:flutter/material.dart';

import '../../../widgets/app_image.dart';

class FillProfilePage extends StatefulWidget {
  const FillProfilePage({Key? key}) : super(key: key);

  @override
  State<FillProfilePage> createState() => _FillProfilePageState();
}

class _FillProfilePageState extends State<FillProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        title: const Text(
          'Fill Your Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _image(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemTextInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 50,
        // child: Input(
        //   textInputAction: textInputAction,
        //   controller: controller,
        //   onChanged: onChanged,
        // ),
      ),
    );
  }

  Widget _image() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: SizedBox(
        height: 200,
        width: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: AppImage(
            localPathOrUrl: 'userData.avartarUrl',
            boxFit: BoxFit.cover,
            width: 200,
            height: 200,
            errorWidget: const Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
