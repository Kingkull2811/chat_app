import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

import '../../../network/model/term_policy_model.dart';

class TermPolicyPage extends StatelessWidget {
  const TermPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Terms & Policies',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: listTermPolicy.length,
          itemBuilder: (context, index) {
            return _itemTermPolicy(listTermPolicy[index]);
          },
        ),
      ),
    );
  }

  Widget _itemTermPolicy(TermPolicyModel item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '${item.index}. ${item.title}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            item.content,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          )
        ],
      ),
    );
  }
}
