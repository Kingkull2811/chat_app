import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  final String? imageUrl;

  const PhotoViewPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      showCupertinoMessageDialog(context, 'Image not found', onCloseDialog: () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 24,
              color: Colors.white,
            )),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl!),
        loadingBuilder: (context, progress) => const AnimationLoading(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        gaplessPlayback: false,
        customSize: MediaQuery.of(context).size,
        // heroAttributes: const PhotoViewHeroAttributes(
        //   tag: "someTag",
        //   transitionOnUserGestures: true,
        // ),
        // scaleStateChangedCallback: this.onScaleStateChanged,
        // enableRotation: true,
        // controller: controller,
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: PhotoViewComputedScale.covered * 5,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
        // scaleStateCycle: scaleStateCycle,
      ),
    );
  }
}
