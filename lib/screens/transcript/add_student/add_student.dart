import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';
import '../../../utilities/utils.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return GestureDetector(
      onTap: () => clearFocus(context),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.grey[50],
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Add a new student',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Student name:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: _inputText(context,
                              controller: _nameController,
                              inputAction: TextInputAction.next,
                              hintText: 'student name'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: _inputText(context,
                              controller: _nameController,
                              inputAction: TextInputAction.next,
                              hintText: 'student name'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputText(
    BuildContext context, {
    TextEditingController? controller,
    TextInputAction? inputAction,
    String? initText,
    String? hintText,
    IconData? icon,
  }) {
    if (initText != null) {
      controller?.text = initText;
      controller?.selection = TextSelection(
        baseOffset: 0,
        extentOffset: initText.length,
      );
    }
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: inputAction ?? TextInputAction.done,
        onSubmitted: (value) {},
        onChanged: (_) {},
        keyboardType: TextInputType.text,
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 26, 26, 26), height: 1.35),
        decoration: InputDecoration(
            prefixIcon: isNotNullOrEmpty(icon)
                ? Icon(icon, size: 24, color: AppColors.greyLight)
                : null,
            prefixIconColor: AppColors.greyLight,
            contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            filled: true,
            fillColor: const Color.fromARGB(102, 230, 230, 230),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(128, 130, 130, 130),
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6))),
      ),
    );
  }
}
