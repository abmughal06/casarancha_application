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

import '../../../models/providers/user_data_provider.dart';
import '../../../models/user_model.dart';
import '../../../resources/localization_text_strings.dart';

import '../../../resources/strings.dart';
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
    // Get.off(() => const DashBoard());
    final dasboardController =
        Provider.of<DashboardProvider>(context, listen: false);
    dasboardController.changePage(5);
  }
}

class AppUserScreen extends StatefulWidget {
  const AppUserScreen({
    super.key,
    required this.appUserId,
    // required this.appUserName,
  });

  final String appUserId;
  // final String appUserName;

  @override
  State<AppUserScreen> createState() => _AppUserScreenState();
}

class _AppUserScreenState extends State<AppUserScreen> {
  late ProfileProvider profileProvider;
  int postCount = 0;

  @override
  Widget build(BuildContext context) {
    // final post = context.watch<List<PostModel>?>();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final ghost = Provider.of<DashboardProvider>(context);
    var currentUser = context.watch<UserModel?>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          color: Colors.black,
          icon: SvgPicture.asset(icIosBackArrow),
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
                StreamProvider.value(
                  value: DataProvider().getSingleUser(widget.appUserId),
                  initialData: null,
                  catchError: (context, error) => null,
                  child: Consumer<UserModel?>(
                    builder: (context, user, b) {
                      if (user == null || currentUser == null) {
                        return const ProfileTopLoader();
                      } else {
                        return Column(
                          children: [
                            Card(
                              color: colorWhite,
                              shape: const CircleBorder(
                                  side:
                                      BorderSide(color: colorWhite, width: 3)),
                              elevation: 2,
                              child: ProfilePic(
                                pic: user.imageStr,
                                showBorder: false,
                                heightAndWidth: 105.h,
                              ),
                            ),
                            heightBox(15.w),
                            SelectableText.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${user.name} ",
                                    style: TextStyle(
                                      color: color13F,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Visibility(
                                      visible: user.isVerified,
                                      child: SvgPicture.asset(
                                        icVerifyBadge,
                                        height: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SelectableTextWidget(
                              text: user.username,
                              color: colorAA3,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                            ),
                            heightBox(8.h),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StreamProvider.value(
                                    initialData: null,
                                    value: DataProvider().posts(),
                                    catchError: (context, error) => null,
                                    child: Consumer<List<PostModel>?>(
                                        builder: (context, post, b) {
                                      if (post == null) {
                                        return profileCounter(
                                            ontap: null,
                                            count: '0',
                                            strText: strProfilePost);
                                      }
                                      return profileCounter(
                                          ontap: null,
                                          count: post
                                              .where((element) =>
                                                  element.creatorId == user.id)
                                              .toList()
                                              .length
                                              .toString(),
                                          strText: strProfilePost);
                                    })),
                                verticalLine(
                                    height: 24.h, horizontalMargin: 30.w),
                                GestureDetector(
                                  onTap: () => Get.to(
                                      () => AppUserFollowerFollowingScreen(
                                            appUser: user,
                                            follow: true,
                                          )),
                                  child: PostFollowCount(
                                    count: user.followersIds.length,
                                    countText: strProfileFollowers,
                                  ),
                                ),
                                verticalLine(
                                    height: 24.h, horizontalMargin: 30.w),
                                GestureDetector(
                                  onTap: () => Get.to(
                                      () => AppUserFollowerFollowingScreen(
                                            appUser: user,
                                          )),
                                  child: PostFollowCount(
                                    count: user.followingsIds.length,
                                    countText: strProfileFollowing,
                                  ),
                                ),
                              ],
                            ),
                            heightBox(20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: user.education.isNotEmpty,
                                    child: SelectableText.rich(
                                      TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.school,
                                              size: 16.sp,
                                              color: color55F,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ${user.education} ',
                                            style: TextStyle(
                                              color: color55F,
                                              fontSize: 12.sp,
                                              fontFamily: strFontName,
                                            ),
                                          ),
                                          WidgetSpan(
                                              child: Visibility(
                                                  visible:
                                                      user.isEducationVerified,
                                                  child: SvgPicture.asset(
                                                    icVerifyBadge,
                                                    height: 15,
                                                  ))),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Visibility(
                                    visible: user.work.isNotEmpty,
                                    child: SelectableText.rich(
                                      TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.work,
                                              size: 15.sp,
                                              color: color55F,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ${user.work} ',
                                            style: TextStyle(
                                              color: color55F,
                                              fontFamily: strFontName,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          WidgetSpan(
                                              child: Visibility(
                                                  visible: user.isWorkVerified,
                                                  child: SvgPicture.asset(
                                                    icVerifyBadge,
                                                    height: 15,
                                                  ))),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Visibility(
                                    visible: user.bio.isNotEmpty,
                                    child: SelectableTextWidget(
                                      text: user.bio,
                                      textAlign: TextAlign.center,
                                      color: color55F,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            heightBox(user.bio.isEmpty ? 0 : 15.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          profileProvider.toggleFollowBtn(
                                              userModel: currentUser,
                                              appUserId: user.id),
                                      child: Container(
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: currentUser.followingsIds
                                                  .contains(user.id)
                                              ? colorWhite
                                              : colorF03,
                                          border: Border.all(
                                            width: 1.w,
                                            color: currentUser.followingsIds
                                                    .contains(user.id)
                                                ? color221
                                                : Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  colorBlack.withOpacity(.06),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                            BoxShadow(
                                              color:
                                                  colorBlack.withOpacity(.04),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: TextWidget(
                                            text: currentUser.followingsIds
                                                    .contains(user.id)
                                                ? strUnFollow
                                                : strSrcFollow,
                                            color: color13F,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
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
                                                firstMessagebyMe: true,
                                                creatorDetails: CreatorDetails(
                                                  name: user.name,
                                                  imageUrl: user.imageStr,
                                                  isVerified: user.isVerified,
                                                ),
                                              )
                                            : ChatScreen(
                                                appUserId: user.id,
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
                    },
                  ),
                ),
              ],
            ),
          )
        ],
        body: StreamProvider.value(
          value: DataProvider().getSingleUser(widget.appUserId),
          initialData: null,
          catchError: (context, error) => null,
          child: Consumer<UserModel?>(builder: (context, user, b) {
            if (user == null) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
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
                    indicatorPadding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(
                        child: Text(strQuote),
                      ),
                      Tab(
                        child: Text(strImages),
                      ),
                      Tab(
                        child: Text(strVideos),
                      ),
                      Tab(
                        child: Text(strMusic),
                      ),
                    ],
                  ),
                  heightBox(10.w),
                  StreamProvider.value(
                    initialData: null,
                    value: DataProvider().posts(),
                    catchError: (context, error) => null,
                    child:
                        Consumer<List<PostModel>?>(builder: (context, post, b) {
                      if (post == null) {
                        return centerLoader();
                      }
                      postCount = post
                          .where((element) => element.creatorId == user.id)
                          .map((e) => e)
                          .toList()
                          .length;
                      return Expanded(
                        child: TabBarView(
                          children: [
                            //qoute
                            QoutesGridView(
                              qoutesList: post
                                  .where((element) =>
                                      element.creatorId == user.id &&
                                      element.mediaData.first.type == 'Qoute')
                                  .toList(),
                            ),
                            ImageGridView(
                              imageList: post
                                  .where((element) =>
                                      element.creatorId == user.id &&
                                      element.mediaData.first.type == 'Photo')
                                  .toList(),
                            ),
                            VideoGridView(
                              videoList: post
                                  .where((element) =>
                                      element.creatorId == user.id &&
                                      element.mediaData.first.type == 'Video')
                                  .toList(),
                            ),
                            //music
                            MusicGrid(
                              musicList: post
                                  .where((element) =>
                                      element.creatorId == user.id &&
                                      element.mediaData.first.type == 'Music')
                                  .toList(),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PostFollowCount extends StatelessWidget {
  const PostFollowCount({
    super.key,
    required this.count,
    required this.countText,
  });

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
