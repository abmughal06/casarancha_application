import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../models/story_model.dart';
import '../../resources/image_resources.dart';
import '../../screens/home/story_view_screen.dart';

class MyStoryWidget extends StatelessWidget {
  MyStoryWidget({Key? key, required this.stories}) : super(key: key);
  final Story? stories;
  final twentyFourHoursAgo = DateTime.now().subtract(const Duration(hours: 24));

  @override
  Widget build(BuildContext context) {
    if (stories!.mediaDetailsList.isEmpty || stories == null) {
      return GestureDetector(
        onTap: () {
          // Get.to(() => AddStoryScreen());
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
              onTap: () => Get.to(() => MyStoryViewScreen(story: stories!)),
              child: Container(
                height: 50.h,
                width: 50.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(stories!.creatorDetails.imageUrl))),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () {
                  // Get.to(() => AddStoryScreen());
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
            // Get.to(() => AddStoryScreen());
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
  const AppUserStoryWidget({Key? key, required this.story}) : super(key: key);
  final Story story;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w, top: 5.w),
      child: InkWell(
        onTap: () {
          Get.to(
            () => StoryViewScreen(story: story),
          );
        },
        child: Stack(
          children: [
            Container(
              height: 50.h,
              width: 50.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(story.creatorDetails.imageUrl),
                ),
              ),
            ),
            Visibility(
              visible: story.creatorDetails.isVerified,
              child: Positioned(
                bottom: 10,
                right: 0,
                child: SvgPicture.asset(icVerifyBadge),
              ),
            )
          ],
        ),
      ),
    );
  }
}
