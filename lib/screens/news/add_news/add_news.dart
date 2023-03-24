import 'dart:io';

import 'package:chat_app/screens/news/news.dart';
import 'package:chat_app/screens/news/news_bloc.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({Key? key}) : super(key: key);

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final _titleController = TextEditingController();
  final _focusNode = FocusNode();
  late RenderBox box;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 24,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Add News',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          const Divider(
            height: 0.5,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: SizedBox(
              height: 200,
              child: CupertinoTextField(
                padding: const EdgeInsets.all(8),
                controller: _titleController,
                focusNode: _focusNode,
                onChanged: (_) {},
                onSubmitted: (_) {},
                placeholder: 'Write the description...',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  height: 1.3,
                  color: Colors.black,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                scrollPhysics: const BouncingScrollPhysics(),
                maxLines: null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 16 * 2,
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _itemAddNews.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 6, 6),
                      child: GestureDetector(
                        onTap: () {
                          _showPickerOption();
                        },
                        child: Container(
                          width: 70,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _itemAddNews[index - 1].urlImage,
                            fit: BoxFit.cover,
                            width: 70,
                            height: 100,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: SizedBox(
                          height: 18,
                          width: 18,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _itemAddNews.removeAt(index - 1);
                              });
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 18,
                              color: AppConstants().red700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PrimaryButton(
              text: 'Post News',
              // isDisable: !(_titleController.text.isEmpty && _itemAddNews.isEmpty),
              onTap:
                  // (_titleController.text.isEmpty && _itemAddNews.isEmpty) ? null : // => backToNews(context),
                  () async {
                //todo: post news, clean _itemAddNews before switch screen
                print('post news');
                // showLoading(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => NewsBloc(context),
                      child: const NewsPage(),
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPickerOption() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final imagePath = await pickImageFromGallery(context);
                if (imagePath != null) {
                  setState(() {
                    _itemAddNews.add(ListImageAddNews(urlImage: imagePath));
                  });
                }
              },
              child: const Text(
                'Pick image from Gallery',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final imagePath = await pickImageFromCamera(context);
                if (imagePath != null) {
                  setState(() {
                    _itemAddNews.add(ListImageAddNews(urlImage: imagePath));
                  });
                }
              },
              child: const Text(
                'Take image from Camera',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

List<ListImageAddNews> _itemAddNews = [];

class ListImageAddNews {
  // final String title;
  final File urlImage;

  ListImageAddNews({
    // required this.title,
    required this.urlImage,
  });
}
