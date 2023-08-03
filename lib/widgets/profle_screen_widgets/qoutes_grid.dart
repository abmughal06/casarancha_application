import 'package:casarancha/widgets/home_screen_widgets/post_detail_media.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';

class QoutesGridView extends StatelessWidget {
  const QoutesGridView({Key? key, required this.qoutesList}) : super(key: key);

  final List<PostModel>? qoutesList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: qoutesList!.isNotEmpty &&
              qoutesList!.map((e) => e.mediaData).isNotEmpty,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: qoutesList!.length,
            itemBuilder: (context, index) {
              final data = qoutesList![index];
              final String quote = data.mediaData[0].link;
              return Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () => Get.to(
                      () => PostFullScreenView(post: data, isPostDetail: true)),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 0.1,
                      color: Colors.grey,
                    )),
                    alignment: Alignment.center,
                    child: Text(
                      quote.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Visibility(
          visible: qoutesList!.isEmpty &&
              qoutesList!.map((e) => e.mediaData).isEmpty,
          child: const Center(
            child: TextWidget(
              text: "No Quotes are available to show",
            ),
          ),
        )
      ],
    );
  }
}
