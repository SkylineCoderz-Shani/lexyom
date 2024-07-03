import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ScreenProfileView extends StatelessWidget {
  final String imageUrl;
  final String title;

  ScreenProfileView({
    required this.imageUrl,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}