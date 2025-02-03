import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/provider/memberImages_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:client/provider/team_provider.dart';

class FullScreenImage extends ConsumerStatefulWidget {
  int selectedIndex = 0;
  FullScreenImage({super.key, required this.selectedIndex});
  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends ConsumerState<FullScreenImage> {
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.selectedIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedTeamNo = ref.read(selectedTeamProvider);
      ref.read(memberImagesProvider.notifier).fetchMemberImages(selectedTeamNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mem_images = ref.watch(memberImagesProvider);

    final photoview = PhotoViewGallery.builder(
        pageController: pageController,
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(mem_images[index].memberfileimages),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        itemCount: mem_images.length);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: photoview,
          )),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]).then((_) {
                  Navigator.of(context).pop(); // Đóng màn hình
                });
              },
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.rotate_right, color: Colors.white),
              onPressed: () {
                // Xoay màn hình
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft,
                ]).then((_) {
                  // Xoay màn hình
                  Navigator.of(context).pop(); // Quay lại màn hình trước
                  // Mở lại màn hình FullScreenImage
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImage(selectedIndex: widget.selectedIndex),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
