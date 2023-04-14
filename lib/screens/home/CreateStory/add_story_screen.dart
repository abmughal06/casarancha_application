import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/screens/home/CreateStory/add_story_controller.dart';

import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../widgets/common_button.dart';

class AddStoryScreen extends StatelessWidget {
  AddStoryScreen({Key? key}) : super(key: key);

  final AddStoryController addStoryController = Get.put(AddStoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: 'Add Story', actions: [
        IconButton(
          onPressed: () {
            Get.bottomSheet(
              CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Get.back();

                      addStoryController.getMedia(type: 'Photo');
                    },
                    child: const Text(
                      'Photo',
                    ),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Get.back();

                      addStoryController.getMedia(type: 'Video');
                    },
                    child: const Text(
                      'Video',
                    ),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
              ),
            );
          },
          icon: Image.asset(
            imgAddPost,
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => CommonButton(
          text:
              addStoryController.isSharingStory.value ? 'Wait' : 'Share Story',
          height: 58.w,
          verticalOutMargin: 10.w,
          horizontalOutMargin: 10.w,
          onTap: addStoryController.shareStory,
        ),
      ),
      body: Obx(
        () => addStoryController.mediaFile.value != null
            ? Padding(
                padding: EdgeInsets.only(
                  bottom: 10.w,
                ),
                child: Column(
                  children: [
                    addStoryController.mediaUploadTasks.value == null
                        ? Container()
                        : StreamBuilder<TaskSnapshot>(
                            stream: addStoryController
                                .mediaUploadTasks.value!.snapshotEvents,
                            builder: (BuildContext context,
                                AsyncSnapshot<TaskSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                double progress =
                                    data.bytesTransferred / data.totalBytes;

                                return Stack(
                                  children: [
                                    LinearProgressIndicator(
                                      value: progress,
                                    ),
                                    Center(
                                      child: Text(
                                        '${(100 * progress).roundToDouble()}%',
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return const SizedBox(
                                  height: 50,
                                );
                              }
                            },
                          ),
                    AspectRatio(
                      aspectRatio: 9 / 13,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.r,
                            ),
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10.r,
                                ),
                              ),
                              child: addStoryController.mediaData.value.type ==
                                      'Photo'
                                  ? Image.file(
                                      addStoryController.mediaFile.value!,
                                      fit: BoxFit.cover,
                                    )
                                  : VideoPlayerWithFile(
                                      videoFile:
                                          addStoryController.mediaFile.value!,
                                    ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  addStoryController.removeMedia();
                                },
                                icon: SvgPicture.asset(
                                  icRemovePost,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
