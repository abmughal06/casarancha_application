import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_detail_media.dart';
import 'package:casarancha/widgets/shared/alert_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';

class MusicGrid extends StatelessWidget {
  const MusicGrid({Key? key, required this.musicList}) : super(key: key);

  final List<PostModel> musicList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: musicList.isNotEmpty &&
              musicList.map((e) => e.mediaData).isNotEmpty,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
            ),
            itemCount: musicList.length,
            itemBuilder: (context, index) {
              // final data = musicList[index].mediaData[0];

              return GestureDetector(
                onTap: () => Get.to(() => PostFullScreenView(
                    post: musicList[index], isPostDetail: false)),
                child: Container(
                    color: colorF03.withOpacity(0.6),
                    child: Icon(Icons.music_note, size: 35.sp)),
              );
            },
          ),
        ),
        Visibility(
          visible:
              musicList.isEmpty && musicList.map((e) => e.mediaData).isEmpty,
          child: const AlertText(
            text: "No Music are available to show",
          ),
        )
      ],
    );
  }
}
