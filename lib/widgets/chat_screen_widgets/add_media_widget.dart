import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddMediaWidget extends StatelessWidget {
  const AddMediaWidget({super.key, required this.chatProvider});
  final ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Get.bottomSheet(
            CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {},
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                chatProvider.getMusic();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10.h),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  child: const Icon(
                                    Icons.music_note,
                                    color: colorWhite,
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                chatProvider.getVideo(context);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10.h),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                  child: const Icon(
                                      Icons.video_collection_outlined,
                                      color: colorWhite)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                chatProvider.getPhoto(context);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10.h),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange),
                                  child: const Icon(Icons.photo,
                                      color: colorWhite)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                chatProvider.takeCameraPic(context);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10.h),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepOrange),
                                  child: const Icon(Icons.camera_alt,
                                      color: colorWhite)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                chatProvider.getMedia(context);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10.h),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.purple),
                                  child: const Icon(Icons.file_copy_sharp,
                                      color: colorWhite)),
                            ),
                          ],
                        ),
                      ],
                    ),
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
        child: const CircleAvatar(
          backgroundColor: colorFF4,
          child: Icon(
            Icons.add,
            color: color080,
          ),
        ),
      ),
    );
  }
}
