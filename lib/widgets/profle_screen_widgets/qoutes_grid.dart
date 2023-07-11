import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import 'full_screen_qoute.dart';

class QoutesGridView extends StatelessWidget {
  const QoutesGridView({Key? key, required this.qoutesList}) : super(key: key);

  final List<PostModel>? qoutesList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: qoutesList!.isNotEmpty,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: qoutesList!.length,
            itemBuilder: (context, index) {
              final data = qoutesList![index];
              final String quote = data.mediaData[0].link;
              // print(quote);
              return Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () => Get.to(() => Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            FullScreenQoute(
                              qoute: quote,
                              post: data,
                            ),
                          ],
                        ),
                      )),
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
          visible: qoutesList!.isEmpty,
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
