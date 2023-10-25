import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_detail_media.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../shared/alert_text.dart';

class ImageGridView extends StatelessWidget {
  const ImageGridView({Key? key, required this.imageList}) : super(key: key);

  final List<PostModel>? imageList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: imageList!.isNotEmpty &&
              imageList!.map((e) => e.mediaData).isNotEmpty,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
            ),
            itemCount: imageList!.length,
            itemBuilder: (context, index) {
              final data = imageList![index];
              // final String image = data.mediaData[0].link;
              // print(quote);
              return Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () => Get.to(
                      () => PostFullScreenView(post: data, isPostDetail: true)),
                  child: CachedNetworkImage(
                    imageUrl: data.mediaData[0].link,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        Visibility(
          visible:
              imageList!.isEmpty && imageList!.map((e) => e.mediaData).isEmpty,
          child: const AlertText(
            text: strAlertImage,
          ),
        )
      ],
    );
  }
}
