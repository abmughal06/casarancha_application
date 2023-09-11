import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_screen.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/ghost_chat_screen.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/widgets/profle_screen_widgets/profile_top_loader.dart';
import 'package:casarancha/widgets/profle_screen_widgets/qoutes_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../resources/localization_text_strings.dart';

import '../../../widgets/common_widgets.dart';
import '../../../widgets/menu_user_button.dart';
import '../../../widgets/profile_pic.dart';
import '../../../widgets/profle_screen_widgets/image_grid.dart';
import '../../../widgets/profle_screen_widgets/music_grid.dart';
import '../../../widgets/profle_screen_widgets/video_grid.dart';
import '../../../widgets/text_widget.dart';
import '../follower_following_screen.dart';

void navigateToAppUserScreen(userId, context) {
  if (userId != FirebaseAuth.instance.currentUser!.uid) {
    Get.to(() => AppUserScreen(appUserId: userId));
  } else {
    final dasboardController =
        Provider.of<DashboardProvider>(context, listen: false);
    dasboardController.changePage(5);
  }
}

class AppUserScreen extends StatefulWidget {
  const AppUserScreen({
    Key? key,
    required this.appUserId,
    // required this.appUserName,
  }) : super(key: key);

  final String appUserId;
  // final String appUserName;

  @override
  State<AppUserScreen> createState() => _AppUserScreenState();
}

class _AppUserScreenState extends State<AppUserScreen> {
  @override
  Widget build(BuildContext context) {
    final post = context.watch<List<PostModel>?>();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final ghost = Provider.of<DashboardProvider>(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              color: Colors.black,
              icon: const Icon(Icons.keyboard_arrow_left_rounded),
            ),
            actions: [
              menuUserButton(
                context,
                widget.appUserId,
                "",
              ),
              widthBox(15.w),
            ],
          ),
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Consumer<List<UserModel>?>(
                            builder: (context, appUser, b) {
                              if (appUser == null) {
                                return const ProfileTopLoader();
                              } else {
                                var userList = appUser
                                    .where((element) =>
                                        element.id == widget.appUserId)
                                    .toList();

                                var currentUser = appUser
                                    .where((element) =>
                                        element.id ==
                                        FirebaseAuth.instance.currentUser!.uid)
                                    .first;
                                UserModel? user =
                                    userList.isNotEmpty ? userList.first : null;
                                if (user == null) {
                                  return Container();
                                } else {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 45.w),
                                        child: Row(
                                          children: [
                                            ProfilePic(
                                              pic: user.imageStr,
                                              showBorder: true,
                                            ),
                                            widthBox(13.w),
                                            Expanded(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                horizontalTitleGap: 0,
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SelectableTextWidget(
                                                          text: user.name,
                                                          color: color13F,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16.sp,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                        Visibility(
                                                            visible:
                                                                user.isVerified,
                                                            child: SvgPicture
                                                                .asset(
                                                                    icVerifyBadge))
                                                      ],
                                                    ),
                                                    SelectableTextWidget(
                                                      text: user.username,
                                                      color: colorAA3,
                                                      fontSize: 12.sp,
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          user.work.isNotEmpty,
                                                      child: Row(
                                                        children: [
                                                          SelectableTextWidget(
                                                            text:
                                                                'Works at ${user.work}',
                                                            color: colorAA3,
                                                            fontSize: 12.sp,
                                                          ),
                                                          Visibility(
                                                            visible: user
                                                                .isWorkVerified,
                                                            child: SvgPicture
                                                                .asset(
                                                                    icVerifyBadge),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: user
                                                          .education.isNotEmpty,
                                                      child: Row(
                                                        children: [
                                                          SelectableTextWidget(
                                                            text:
                                                                "studied from ${user.education}",
                                                            color: colorAA3,
                                                            fontSize: 12.sp,
                                                          ),
                                                          Visibility(
                                                            visible: user
                                                                .isEducationVerified,
                                                            child: SvgPicture
                                                                .asset(
                                                                    icVerifyBadge),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      heightBox(20.h),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          post == null
                                              ? const PostFollowCount(
                                                  count: 0,
                                                  countText: strProfilePost)
                                              : PostFollowCount(
                                                  count: post
                                                      .where((element) =>
                                                          element.creatorId ==
                                                              widget
                                                                  .appUserId &&
                                                          element.mediaData[0]
                                                                  .type !=
                                                              'Music')
                                                      .toList()
                                                      .length,
                                                  countText: strProfilePost,
                                                ),
                                          verticalLine(
                                              height: 24.h,
                                              horizontalMargin: 30.w),
                                          GestureDetector(
                                            onTap: () => Get.to(() =>
                                                AppUserFollowerFollowingScreen(
                                                  appUserid: user.id,
                                                  follow: true,
                                                )),
                                            child: PostFollowCount(
                                              count: appUser
                                                  .where((element) => user
                                                      .followersIds
                                                      .contains(element.id))
                                                  .length,
                                              countText: strProfileFollowers,
                                            ),
                                          ),
                                          verticalLine(
                                              height: 24.h,
                                              horizontalMargin: 30.w),
                                          GestureDetector(
                                            onTap: () => Get.to(() =>
                                                AppUserFollowerFollowingScreen(
                                                  appUserid: user.id,
                                                )),
                                            child: PostFollowCount(
                                              count: appUser
                                                  .where((element) => user
                                                      .followingsIds
                                                      .contains(element.id))
                                                  .length,
                                              countText: strProfileFollowing,
                                            ),
                                          ),
                                        ],
                                      ),
                                      heightBox(14.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 27.w),
                                        child: SelectableTextWidget(
                                          text: user.bio,
                                          textAlign: TextAlign.center,
                                          color: color55F,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      heightBox(user.bio.isEmpty ? 0 : 15.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => profileProvider
                                                    .toggleFollowBtn(
                                                        userModel: currentUser,
                                                        appUserId: user.id),
                                                child: Container(
                                                  height: 45.h,
                                                  decoration: BoxDecoration(
                                                    color: currentUser
                                                            .followingsIds
                                                            .contains(user.id)
                                                        ? colorWhite
                                                        : colorF03,
                                                    border: Border.all(
                                                      width: 1.w,
                                                      color: currentUser
                                                              .followingsIds
                                                              .contains(user.id)
                                                          ? color221
                                                          : Colors.transparent,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: colorBlack
                                                            .withOpacity(.06),
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                      BoxShadow(
                                                        color: colorBlack
                                                            .withOpacity(.04),
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        offset:
                                                            const Offset(0, 2),
                                                      )
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: TextWidget(
                                                      text: currentUser
                                                              .followingsIds
                                                              .contains(user.id)
                                                          ? strUnFollow
                                                          : strSrcFollow,
                                                      color: color13F,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            widthBox(8.w),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  () => ghost.checkGhostMode
                                                      ? GhostChatScreen2(
                                                          appUserId: user.id,
                                                          firstMessagebyMe:
                                                              true,
                                                          creatorDetails:
                                                              CreatorDetails(
                                                            name: user.name,
                                                            imageUrl:
                                                                user.imageStr,
                                                            isVerified:
                                                                user.isVerified,
                                                          ),
                                                        )
                                                      : ChatScreen(
                                                          appUserId: user.id,
                                                          creatorDetails:
                                                              CreatorDetails(
                                                            name: user.name,
                                                            imageUrl:
                                                                user.imageStr,
                                                            isVerified:
                                                                user.isVerified,
                                                          ),
                                                        ),
                                                );
                                              },
                                              child: Image.asset(
                                                imgProMsg,
                                                height: 60.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
              body: Consumer<List<UserModel>?>(builder: (context, appUser, b) {
                if (appUser == null) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  var userList = appUser
                      .where((element) => element.id == widget.appUserId)
                      .toList();
                  UserModel? user = userList.isNotEmpty ? userList.first : null;
                  if (user == null) {
                    return const Center(
                      child: TextWidget(
                        text: "User no longer exists",
                      ),
                    );
                  } else {
                    return DefaultTabController(
                      length: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TabBar(
                            labelColor: colorPrimaryA05,
                            unselectedLabelColor: colorAA3,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                            indicatorColor: colorF03,
                            indicatorPadding: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 10.w),
                            dividerColor: Colors.transparent,
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
                                child: Text('Music'),
                              ),
                            ],
                          ),
                          heightBox(10.w),
                          Expanded(
                            child: TabBarView(
                              children: [
                                //qoute
                                post == null
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive())
                                    : QoutesGridView(
                                        qoutesList: post
                                            .where((element) =>
                                                element.creatorId ==
                                                    widget.appUserId &&
                                                element.mediaData[0].type ==
                                                    'Qoute')
                                            .toList(),
                                      ),
                                post == null
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive())
                                    : ImageGridView(
                                        imageList: post
                                            .where((element) =>
                                                element.creatorId ==
                                                    widget.appUserId &&
                                                element.mediaData[0].type ==
                                                    'Photo')
                                            .toList(),
                                      ),
                                post == null
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive())
                                    : VideoGridView(
                                        videoList: post
                                            .where((element) =>
                                                element.creatorId ==
                                                    widget.appUserId &&
                                                element.mediaData[0].type ==
                                                    'Video')
                                            .toList(),
                                      ),
                                //story
                                post == null
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive())
                                    : MusicGrid(
                                        musicList: post
                                            .where((element) =>
                                                element.creatorId == user.id &&
                                                element.mediaData.first.type ==
                                                    'Music')
                                            .toList(),
                                      ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
              })),
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
