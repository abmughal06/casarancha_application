import 'dart:typed_data';

import 'package:casarancha/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatelessWidget {
  const VideoThumbnailWidget({super.key, required this.videoUrl});
  final String videoUrl;

  Future<Uint8List?> videoThumbnail() async {
    return await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: videoThumbnail(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Container(
            color: colorBlack.withOpacity(0.04),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: colorWhite,
            image: snap.data != null
                ? DecorationImage(
                    image: MemoryImage(snap.data!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        );
      },
    );
  }
}
