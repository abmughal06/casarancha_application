import 'dart:developer';

import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../resources/image_resources.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../widgets/home_screen_widgets/post_card.dart';
import '../../../widgets/home_screen_widgets/story_widget.dart';
import '../notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void didUpdateWidget(covariant oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // if (oldWidget.durationInSeconds != widget.durationInSeconds) {
  //   //   _controller.duration = Duration(seconds: widget.durationInSeconds);
  //   //   _controller.repeat(reverse: true);
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          strCasaRanch,
          style: TextStyle(
            color: color13F,
            fontFamily: strFontName,
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
          ),
        ),
        elevation: 0,
        // leading: ghostModeBtn(homeCtrl: homeScreenController),
        actions: [
          IconButton(
            onPressed: () {
              // Get.to(() => CreatePostScreen());
            },
            icon: Image.asset(
              imgAddPost,
            ),
          ),
          Consumer<List<NotificationModel>?>(
            builder: (context, notification, b) {
              if (notification == null) {
                return IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    icNotifyBell,
                  ),
                );
              }
              return IconButton(
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                },
                icon: Badge(
                  label: Text(notification
                      .where((element) => element.isRead == false)
                      .toList()
                      .length
                      .toString()),
                  isLabelVisible: notification
                      .where((element) => element.isRead == false)
                      .toList()
                      .isNotEmpty,
                  child: SvgPicture.asset(
                    icNotifyBell,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 77.h,
            child: Consumer<List<Story>?>(
              builder: (context, provider, b) {
                if (provider == null) {
                  return const CircularProgressIndicator();
                } else {
                  var filterList = provider
                      .where((element) => element.creatorId != currentUser!.id)
                      .toList();
                  log("${provider.where((element) => element.creatorId == currentUser!.id).toList().isNotEmpty}");
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        provider
                                .where((element) =>
                                    element.creatorId == currentUser!.id)
                                .toList()
                                .isNotEmpty
                            ? MyStoryWidget(
                                stories: provider
                                    .where((element) =>
                                        element.creatorId == currentUser!.id)
                                    .first,
                              )
                            : GestureDetector(
                                onTap: () {
                                  // Get.to(() => AddStoryScreen());
                                },
                                child: SvgPicture.asset(
                                  icProfileAdd,
                                  height: 50.h,
                                  width: 50.h,
                                ),
                              ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            itemCount: filterList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var storyList = [];
                              final twentyFourHoursAgo = DateTime.now()
                                  .subtract(const Duration(hours: 24));
                              DateTime givenDate = DateTime.now();

                              for (int i = 0;
                                  i < filterList[index].mediaDetailsList.length;
                                  i++) {
                                givenDate = DateTime.parse(
                                    filterList[index].mediaDetailsList[i].id);
                                if (givenDate.isAfter(twentyFourHoursAgo)) {
                                  storyList.add(filterList[index]);
                                }
                              }

                              if (storyList.contains(filterList[index])) {
                                return AppUserStoryWidget(
                                  story: filterList[index],
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Consumer<List<PostModel>?>(
            builder: (context, posts, b) {
              if (posts == null) {
                return Container();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts
                      .where((element) => element.mediaData.isNotEmpty)
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: posts
                          .where((element) => element.mediaData.isNotEmpty)
                          .toList()[index],
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
