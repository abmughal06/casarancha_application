import 'dart:developer';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/widgets/home_screen_widgets/story_views_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';
import '../../resources/color_resources.dart';
import '../../widgets/common_widgets.dart';

class MyStoryViewScreen extends StatefulWidget {
  const MyStoryViewScreen({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  State<MyStoryViewScreen> createState() => _MyStoryViewScreenState();
}

class _MyStoryViewScreenState extends State<MyStoryViewScreen> {
  StoryController? controller;
  late TextEditingController commentController;
  final FocusNode _commentFocus = FocusNode();

  List<MediaDetails> storyItems = [];
  DateTime twentyFourHoursAgo =
      DateTime.now().subtract(const Duration(hours: 24));

  @override
  void initState() {
    super.initState();
    controller = StoryController();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    controller!.dispose();
    commentController.dispose();
    super.dispose();
    currentIndex.value = 0;
  }

  var currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    controller = StoryController();
    storyItems = widget.story.mediaDetailsList
        .where(
            (element) => DateTime.parse(element.id).isAfter(twentyFourHoursAgo))
        .toList();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            StoryView(
              storyItems: [
                ...storyItems.asMap().entries.map((e) {
                  // print("==============  ${e.value.type}");
                  return e.value.type == "Photo"
                      ? StoryItem.pageImage(
                          key: ValueKey(e.key),
                          url: e.value.link,
                          duration: const Duration(seconds: 5),
                          controller: controller!,
                        )
                      : StoryItem.pageVideo(e.value.link,
                          key: ValueKey(e.key),
                          controller: controller!,
                          duration: const Duration(seconds: 15));
                })
              ],
              controller: controller!,
              onComplete: () {
                Get.back();
              },
              onStoryShow: (s) async {
                currentIndex.value = int.parse(s.view.key
                    .toString()
                    .replaceAll("[", "")
                    .replaceAll("]", "")
                    .replaceAll("<", "")
                    .replaceAll(">", ""));
                log("=============================== > ${s.view.key}");
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Get.back();
                }
              },
            ),
            Visibility(
              visible: _commentFocus.hasFocus,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
              ),
            ),
            Visibility(
              visible: !_commentFocus.hasFocus,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.5,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      controller!.pause();
                      Get.bottomSheet(storyViews(story: widget.story));
                    },
                    child: SizedBox(
                      width: 100.w,
                      child: Row(
                        children: [
                          widthBox(10.w),
                          const Icon(
                            Icons.visibility,
                            color: color887,
                          ),
                          widthBox(5.w),
                          TextWidget(
                            text: storyItems[currentIndex.value]
                                .storyViews!
                                .length
                                .toString(),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: color887,
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (storyItems[currentIndex.value].id ==
                          storyItems.last.id) {
                        Get.back();

                        // print("last");
                        var ref1 = FirebaseFirestore.instance
                            .collection("stories")
                            .doc(widget.story.creatorId);
                        var ref = await ref1.get();

                        List<dynamic> storyRef =
                            ref.data()!['mediaDetailsList'];

                        storyRef.removeWhere((element) =>
                            element['id'] == storyItems[currentIndex.value].id);

                        await ref1.update({"mediaDetailsList": storyRef});
                      } else {
                        var ref1 = FirebaseFirestore.instance
                            .collection("stories")
                            .doc(widget.story.creatorId);
                        var ref = await ref1.get();

                        List<dynamic> storyRef =
                            ref.data()!['mediaDetailsList'];

                        storyRef.removeWhere((element) =>
                            element['id'] == storyItems[currentIndex.value].id);
                        await ref1.update({"mediaDetailsList": storyRef});
                        controller!.next();
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
