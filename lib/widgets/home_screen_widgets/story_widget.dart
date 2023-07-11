import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/story_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';

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
      return Stack(
        children: [
          givenDate!.isAfter(twentyFourHoursAgo)
              ? InkWell(
                  onTap: () {
                    // Get.to(() => StoryViewScreen(story: story!));
                  },
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                stories!.creatorDetails.imageUrl))),
                  ),
                )
              : InkWell(
                  onTap: () {
                    // Get.to(() => AddStoryScreen());
                  },
                  child: SvgPicture.asset(
                    icProfileAdd,
                    height: 50.h,
                    width: 50.h,
                  ),
                ),
          givenDate.isAfter(twentyFourHoursAgo)
              ? Positioned(
                  right: -2,
                  bottom: -2,
                  child: InkWell(
                    onTap: () {
                      // Get.to(() => AddStoryScreen());
                    },
                    child: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorPrimaryA05,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        )),
                  ),
                )
              : Container(),
        ],
      );
    }
  }
}

class AppUserStoryWidget extends StatelessWidget {
  const AppUserStoryWidget({Key? key, required this.story}) : super(key: key);
  final Story story;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.to(
        // () => StoryViewScreen(story: story),
        //     );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w, top: 5.w),
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
              right: 10,
              child: SvgPicture.asset(icVerifyBadge),
            ),
          )
        ],
      ),
    );
  }
}
