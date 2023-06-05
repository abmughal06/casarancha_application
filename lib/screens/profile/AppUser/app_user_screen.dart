import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/screens/home/story_view_screen.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_controller.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen.dart';
import 'package:casarancha/widgets/FullImageView.dart';
import 'package:casarancha/widgets/menu_post_button.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:casarancha/widgets/video_player_Url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/profile/follower_following_screen.dart';

import '../../../models/post_creator_details.dart';
import '../../../resources/localization_text_strings.dart';

import '../../../widgets/common_widgets.dart';
import '../../../widgets/menu_user_button.dart';
import '../../../widgets/text_widget.dart';
import '../../chat/Chat one-to-one/chat_screen.dart';

class AppUserScreen extends StatelessWidget {
  const AppUserScreen({
    Key? key,
    required this.appUserController,
  }) : super(key: key);

  final AppUserController appUserController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => appUserController.isGettingUserData.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                  ),
                                ),
                                menuUserButton(
                                  context,
                                  appUserController.appUserData.value.id,
                                  appUserController.appUserData.value.name,
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: colorPrimaryA05, width: 1.5),
                                shape: BoxShape.circle),
                            height: 90.h,
                            width: 90.h,
                            alignment: Alignment.center,
                            child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipOval(
                                    child: FadeInImage(
                                        fit: BoxFit.cover,
                                        placeholder: const AssetImage(
                                            imgUserPlaceHolder),
                                        image: NetworkImage(appUserController
                                            .appUserData.value.imageStr)))),
                          ),
                          heightBox(15.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextWidget(
                                text: appUserController.appUserData.value.name,
                                color: color13F,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              widthBox(6.w),
                              if (appUserController
                                  .appUserData.value.isVerified)
                                SvgPicture.asset(
                                  icVerifyBadge,
                                  width: 17.w,
                                  height: 17.h,
                                )
                            ],
                          ),
                          TextWidget(
                            text: appUserController.appUserData.value.username,
                            color: colorAA3,
                            fontSize: 12.sp,
                          ),
                          heightBox(12.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PostFollowCount(
                                count: appUserController
                                    .appUserData.value.postsIds.length,
                                countText: strProfilePost,
                              ),
                              verticalLine(
                                  height: 24.h, horizontalMargin: 30.w),
                              GestureDetector(
                                onTap: () =>
                                    Get.to(() => FollowerFollowingScreen()),
                                child: Obx(
                                  () => PostFollowCount(
                                    count: appUserController
                                        .appUserData.value.followersIds.length,
                                    countText: strProfileFollowers,
                                  ),
                                ),
                              ),
                              verticalLine(
                                  height: 24.h, horizontalMargin: 30.w),
                              GestureDetector(
                                onTap: () =>
                                    Get.to(() => FollowerFollowingScreen()),
                                child: PostFollowCount(
                                  count: appUserController
                                      .appUserData.value.followingsIds.length,
                                  countText: strProfileFollowing,
                                ),
                              ),
                            ],
                          ),
                          heightBox(14.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 27.w),
                            child: TextWidget(
                              text: appUserController.appUserData.value.bio,
                              textAlign: TextAlign.center,
                              color: color55F,
                              fontSize: 12.sp,
                            ),
                          ),
                          heightBox(20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        appUserController.toggleFollowUser(),
                                    child: Obx(
                                      () => Container(
                                        height: 45.h,
                                        decoration: appUserController
                                                .isFollowing.value
                                            ? BoxDecoration(
                                                color: colorF03,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: colorBlack
                                                        .withOpacity(.06),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                  BoxShadow(
                                                    color: colorBlack
                                                        .withOpacity(.04),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  )
                                                ],
                                              )
                                            : BoxDecoration(
                                                color: colorWhite,
                                                border: Border.all(
                                                    width: 1.w,
                                                    color: color221),
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: colorBlack
                                                        .withOpacity(.06),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                  BoxShadow(
                                                    color: colorBlack
                                                        .withOpacity(.04),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  )
                                                ],
                                              ),
                                        child: Center(
                                          child: appUserController
                                                  .isLoading.value
                                              ? const CircularProgressIndicator
                                                  .adaptive()
                                              : TextWidget(
                                                  text: !appUserController
                                                          .isFollowing.value
                                                      ? strSrcFollow
                                                      : strUnFollow,
                                                  color: color13F,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                widthBox(10.w),
                                GestureDetector(
                                  onTap: () => Get.to(() => ChatScreen(
                                        appUserId: appUserController.appUserId,
                                        creatorDetails: CreatorDetails(
                                          name: appUserController
                                              .appUserData.value.name,
                                          imageUrl: appUserController
                                              .appUserData.value.imageStr,
                                          isVerified: appUserController
                                              .appUserData.value.isVerified,
                                        ),
                                      )),
                                  child: Image.asset(
                                    imgProMsg,
                                    height: 60.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          heightBox(15.h),
                        ],
                      ),
                    )
                  ],
                  body: DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        primaryTabBar(
                          tabs: const [
                            Tab(
                              child: Text('Qoutes'),
                            ),
                            Tab(
                              child: Text('Images'),
                            ),
                            Tab(
                              child: Text('Videos'),
                            ),
                            Tab(
                              child: Text('Stories'),
                            ),
                          ],
                        ),
                        heightBox(15.h),
                        Expanded(
                          child: TabBarView(
                            children: [
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount:
                                    appUserController.getUserQuotes.length,
                                itemBuilder: (context, index) {
                                  final String quote = appUserController
                                      .getUserQuotes[index]['link'];
                                  return GestureDetector(
                                    onTap: () => Get.to(
                                      () => FullScreenQoute(
                                        qoute: quote,
                                        post: appUserController
                                            .getUserQuotes[index]['post'],
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        width: 0.1,
                                        color: Colors.grey,
                                      )),
                                      alignment: Alignment.center,
                                      child: Text(
                                        quote,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                ),
                                itemCount:
                                    appUserController.getUserImages.length,
                                itemBuilder: (context, index) {
                                  final String imageUrl = appUserController
                                      .getUserImages[index]['link'];
                                  return GestureDetector(
                                    onTap: () => Get.to(
                                      () => Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Stack(
                                          children: [
                                            FullImageView(
                                              url: imageUrl,
                                            ),
                                            Positioned(
                                              top: 30,
                                              right: 15,
                                              child: menuButton(
                                                context,
                                                appUserController
                                                        .getUserImages[index]
                                                    ['post'],
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 17),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    child: FadeInImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                      placeholder:
                                          const AssetImage(imgImagePlaceHolder),
                                    ),
                                  );
                                },
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount:
                                    appUserController.getUserVideos.length,
                                itemBuilder: (context, index) {
                                  final String videoUrl = appUserController
                                      .getUserVideos[index]['link'];
                                  return GestureDetector(
                                    onTap: () => Get.to(
                                      () => Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Stack(
                                          children: [
                                            VideoPlayerWidget(
                                              videoUrl: videoUrl,
                                            ),
                                            Positioned(
                                              top: 40,
                                              right: 15,
                                              child: menuButton(
                                                  context,
                                                  appUserController
                                                          .getUserVideos[index]
                                                      ['post'],
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 17)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.video_file_rounded,
                                        size: 48,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: appUserController.userStories.length,
                                itemBuilder: (context, index) {
                                  final Story story =
                                      appUserController.userStories[index];
                                  return GestureDetector(
                                    onTap: () => Get.to(
                                      () => StoryViewScreen(
                                        story: story,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.perm_media_rounded,
                                        size: 48,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class PostFollowCount extends StatelessWidget {
  const PostFollowCount({
    Key? key,
    required this.count,
    required this.countText,
  }) : super(key: key);

  final int count;
  final String countText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(
          text: count.toString(),
          color: color13F,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),
        heightBox(3.h),
        TextWidget(
          text: countText,
          color: colorAA3,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ],
    );
  }
}
