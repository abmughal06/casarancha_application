import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/screens/home/CreateStory/add_story_controller.dart';

import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../widgets/common_button.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  // final story addStoryController = Get.put(AddStoryController());
  late AddStoryProvider story;

  @override
  void dispose() {
    super.dispose();

    story.disposeMedia();
  }

  @override
  Widget build(BuildContext context) {
    story = Provider.of<AddStoryProvider>(context, listen: false);
    final user = context.watch<UserModel?>();
    return Scaffold(
      appBar: primaryAppbar(
        title: appText(context).strAddStory,
        actions: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();

                        story.getMedia(type: 'Photo');
                      },
                      child: const Text(
                        'Photo',
                      ),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();

                        story.getMedia(type: 'Video');
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
                    child: Text(
                      appText(context).strCancel,
                    ),
                  ),
                ),
              );
            },
            icon: Image.asset(
              imgAddPost,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer<AddStoryProvider>(
        builder: (context, prov, b) {
          return CommonButton(
            showLoading: prov.isSharingStory,
            text: prov.isSharingStory
                ? appText(context).strWait
                : appText(context).strShareStory,
            height: 58.w,
            verticalOutMargin: 10.w,
            horizontalOutMargin: 10.w,
            onTap: () => prov.shareStory(user: user),
          );
        },
      ),
      body: Consumer<AddStoryProvider>(builder: (context, provider, b) {
        return provider.mediaFile != null
            ? Padding(
                padding: EdgeInsets.only(
                  bottom: 10.w,
                ),
                child: Column(
                  children: [
                    provider.mediaUploadTasks == null
                        ? Container()
                        : StreamBuilder<TaskSnapshot>(
                            stream: provider.mediaUploadTasks!.snapshotEvents,
                            builder: (BuildContext context,
                                AsyncSnapshot<TaskSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                double progress =
                                    data.bytesTransferred / data.totalBytes;
                                var value =
                                    (100 * progress).roundToDouble().toInt();
                                if (value.isNaN || value.isInfinite) {
                                  return const SizedBox(
                                    height: 50,
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 8.h),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 10.h,
                                      semanticsValue: '$value%',
                                      semanticsLabel: '$value%',
                                    ),
                                  );
                                }
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
                              child: provider.mediaData.type == 'Photo'
                                  ? Image.file(
                                      provider.mediaFile!,
                                      fit: BoxFit.cover,
                                    )
                                  : VideoPlayerWithFile(
                                      videoFile: provider.mediaFile!,
                                    ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  provider.removeMedia();
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
            : Container();
      }),
    );
  }
}
