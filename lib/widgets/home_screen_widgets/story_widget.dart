import 'package:casarancha/widgets/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../models/story_model.dart';
import '../../resources/image_resources.dart';
import '../../screens/home/CreateStory/add_story_screen.dart';
import '../../screens/home/my_story_screen.dart';
import '../../screens/home/story_view_screen.dart';

class MyStoryWidget extends StatelessWidget {
  MyStoryWidget({super.key, required this.stories});
  final Story? stories;
  final twentyFourHoursAgo = DateTime.now().subtract(const Duration(hours: 24));

  @override
  Widget build(BuildContext context) {
    if (stories!.mediaDetailsList.isEmpty || stories == null) {
      return GestureDetector(
        onTap: () {
          Get.to(() => const AddStoryScreen());
        },
        child: SvgPicture.asset(
          icProfileAdd,
          height: 50.h,
          width: 50.h,
        ),
      );
    } else {
      DateTime? givenDate;
      for (int i = 0; i < stories!.mediaDetailsList.length; i++) {
        givenDate = DateTime.parse(stories!.mediaDetailsList[i].id);
      }
      if (givenDate!.isAfter(twentyFourHoursAgo)) {
        return Stack(
          children: [
            InkWell(
              onTap: () => Get.to(() => MyStoryViewScreen(stories: stories!)),
              child: ProfilePic(
                heightAndWidth: 50.h,
                pic: stories!.creatorDetails.imageUrl,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () {
                  Get.to(() => const AddStoryScreen());
                },
                child: SvgPicture.asset(
                  icProfileAdd,
                  height: 17.h,
                  width: 17.h,
                ),
              ),
            ),
          ],
        );
      } else {
        return InkWell(
          onTap: () {
            Get.to(() => const AddStoryScreen());
          },
          child: SvgPicture.asset(
            icProfileAdd,
            height: 50.h,
            width: 50.h,
          ),
        );
      }
    }
  }
}

class AppUserStoryWidget extends StatelessWidget {
  const AppUserStoryWidget({super.key, required this.story});
  final Story story;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: InkWell(
        onTap: () {
          Get.to(
            () => StoryViewScreen(
              stories: story,
            ),
          );
        },
        child: Stack(
          children: [
            ProfilePic(
              pic: story.creatorDetails.imageUrl,
              heightAndWidth: 50.w,
            ),
            Visibility(
              visible: story.creatorDetails.isVerified,
              child: Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset(
                  icVerifyBadge,
                  height: 17.h,
                  width: 17.h,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
