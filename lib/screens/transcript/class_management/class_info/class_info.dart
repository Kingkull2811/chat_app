import 'package:chat_app/network/model/class_model.dart';
import 'package:flutter/material.dart';

class ClassInfoPage extends StatefulWidget {
  final bool isEdit;
  final ClassModel? classInfoEdit;

  const ClassInfoPage({
    Key? key,
    this.isEdit = false,
    this.classInfoEdit,
  }) : super(key: key);

  @override
  State<ClassInfoPage> createState() => _ClassInfoPageState();
}

class _ClassInfoPageState extends State<ClassInfoPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
