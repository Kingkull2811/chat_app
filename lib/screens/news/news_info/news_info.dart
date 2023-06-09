import 'dart:developer';
import 'dart:io';

import 'package:chat_app/network/model/news_model.dart';
import 'package:chat_app/network/repository/news_repository.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utilities/enum/media_type.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../widgets/app_image.dart';

class NewsInfo extends StatefulWidget {
  final bool? isEdit;
  final NewsModel? newsInfo;

  const NewsInfo({
    Key? key,
    this.isEdit = false,
    this.newsInfo,
  }) : super(key: key);

  @override
  State<NewsInfo> createState() => _NewsInfoState();
}

class _NewsInfoState extends State<NewsInfo> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late RenderBox box;

  String mediaUrl = '';
  bool isOnline = true;
  bool isChangeMedia = false;

  String videoThumbPath = '';

  /// [mediaType] = 1- image, 2 - video
  MediaType mediaType = MediaType.image;

  final NewsRepository _newsRepository = NewsRepository();

  void initText() {
    if (widget.newsInfo != null) {
      setState(() {
        mediaUrl = widget.newsInfo?.mediaUrl ?? '';
        _titleController.text = widget.newsInfo?.title ?? '';
        _contentController.text = widget.newsInfo?.content ?? '';
      });
    }
  }

  @override
  void initState() {
    initText();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit ?? false;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 24,
              color: Colors.white,
            ),
          ),
          title: Text(
            isEdit ? 'Edit News' : 'Add News',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: CupertinoTextField(
                    padding: const EdgeInsets.all(8),
                    controller: _titleController,
                    onChanged: (_) {},
                    onSubmitted: (_) {},
                    textInputAction: TextInputAction.done,
                    placeholder: 'Write the title ...',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    scrollPhysics: const BouncingScrollPhysics(),
                    maxLines: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    height: 150,
                    child: CupertinoTextField(
                      padding: const EdgeInsets.all(8),
                      controller: _contentController,
                      textInputAction: TextInputAction.none,
                      onChanged: (_) {},
                      onSubmitted: (_) {},
                      placeholder: 'Write the content ...',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      scrollPhysics: const BouncingScrollPhysics(),
                      maxLines: null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 300,
                              minHeight: 150,
                            ),
                            width: MediaQuery.of(context).size.width -
                                16 * 2 -
                                6 * 2,
                            child: Container(
                              color: Colors.grey,
                              child: AppImage(
                                isOnline: isOnline,
                                localPathOrUrl: isNullOrEmpty(videoThumbPath)
                                    ? mediaUrl
                                    : videoThumbPath,
                                boxFit: BoxFit.contain,
                                errorWidget: InkWell(
                                  onTap: () async {
                                    await _pickImage(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 80,
                                          color: Colors.grey.withOpacity(0.4),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Add an image or video',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isNotNullOrEmpty(mediaUrl))
                        Positioned(
                          right: 0,
                          top: 0,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  mediaUrl = '';
                                  mediaType = MediaType.image;
                                  isOnline = true;
                                  videoThumbPath = '';
                                  isChangeMedia = true;
                                });
                              },
                              child: const Icon(
                                Icons.cancel_outlined,
                                size: 20,
                                color: AppColors.red700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: PrimaryButton(
                    text: isEdit ? 'Update' : 'Post News',
                    onTap: () async {
                      showLoading(context);
                      if (isEdit) {
                        await updateNews(context, widget.newsInfo?.id);
                      } else {
                        await postNews(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> postNews(BuildContext context) async {
    final response = await _newsRepository.postNews(
      title: _titleController.text.trim().toString(),
      content: _contentController.text.trim().toString(),
      mediaUrl: await getMediaUrl(mediaUrl),
      mediaType: setMediaType(mediaType),
    );

    if (response is NewsModel) {
      showCupertinoMessageDialog(
        this.context,
        'Post news successfully',
        barrierDismiss: true,
        onClose: () {
          Navigator.pop(context);
          setState(() {
            _titleController.clear();
            _contentController.clear();
            mediaUrl = '';
          });
        },
      );
    } else {
      showCupertinoMessageDialog(
        this.context,
        'Error!',
        content: 'Internal_server_error',
      );
    }
  }

  updateNews(BuildContext context, int? newsId) async {
    if (newsId == null) {
      showCupertinoMessageDialog(this.context, 'the news is not found');
    }

    final response = await _newsRepository.updateNews(
      newsId: newsId!,
      title: _titleController.text.trim().toString(),
      content: _contentController.text.trim().toString(),
      mediaUrl: isChangeMedia ? await getMediaUrl(mediaUrl) : mediaUrl,
      mediaType: setMediaType(mediaType),
    );

    if (response is NewsModel) {
      showCupertinoMessageDialog(
        this.context,
        'Update news successfully',
        barrierDismiss: true,
        buttonLabel: 'Go to news page',
        onClose: () {
          Navigator.pop(context);
          Navigator.of(context).pop(true);
        },
      );
    } else {
      showCupertinoMessageDialog(
        this.context,
        'Error!',
        content: 'Internal_server_error',
      );
    }
  }

  Future<String> getMediaUrl(String filePath) async {
    return await FirebaseService().uploadImageToStorage(
      titleName: 'image_news',
      childFolder: AppConstants.imageNewsChild,
      image: File(filePath),
    );
  }

  Future _pickImage(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final image = await pickPhoto(ImageSource.camera);
                if (isNotNullOrEmpty(image)) {
                  setState(() {
                    mediaUrl = image;
                    mediaType = MediaType.image;
                    isOnline = false;
                  });
                }
              },
              child: const Text(
                'Take a photo from camera',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final image = await pickPhoto(ImageSource.gallery);
                if (isNotNullOrEmpty(image)) {
                  setState(() {
                    mediaUrl = image;
                    mediaType = MediaType.image;
                    isOnline = false;
                  });
                }
              },
              child: const Text(
                'Choose a photo from gallery',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            // CupertinoActionSheetAction(
            //   onPressed: () async {
            //     Navigator.pop(context);
            //     final video = await pickVideo(context, ImageSource.gallery);
            //     log('video: $video');
            //
            //     // File tempVideo = File(video)
            //     //   ..createSync(recursive: true)
            //     //   ..writeAsBytesSync(byteData.buffer.asUint8List(
            //     //       byteData.offsetInBytes, byteData.lengthInBytes));
            //
            //     final thumb = await getVideoThumbnail(video);
            //
            //     // log('videoThumb: $thumb');
            //     if (isNotNullOrEmpty(video)) {
            //       setState(() {
            //         mediaUrl = video;
            //         videoThumbPath = thumb;
            //         mediaType = 2;
            //         isOnline = false;
            //       });
            //     }
            //   },
            //   child: const Text(
            //     'Choose a video from gallery',
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        );
      },
    );
  }

  //todo: fix me late, pickVideo but can't get video thumbnail
  Future<String> getVideoThumbnail(String videoPath) async {
    try {
      // final thumb = await VideoThumbnail.thumbnailFile(
      //   video: videoPath,
      //   thumbnailPath: (await getTemporaryDirectory()).path,
      //   imageFormat: ImageFormat.JPEG,
      //   quality: 100,
      // );

      final appDocDir = await getApplicationDocumentsDirectory();
      final thumbnailPath = join(appDocDir.path, 'thumbnail.jpg');
      //
      // final file = File(thumbnailPath);
      // await file.writeAsBytes(File(thumb!).readAsBytesSync());

      return thumbnailPath;
    } on PlatformException catch (e) {
      log(e.toString());
      return '';
    }
  }
}
