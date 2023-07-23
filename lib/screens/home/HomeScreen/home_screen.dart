import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../models/story_model.dart';
import '../../../resources/image_resources.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../widgets/home_screen_widgets/post_card.dart';
import '../../../widgets/home_screen_widgets/story_widget.dart';
import '../../dashboard/ghost_mode_btn.dart';
import '../CreatePost/create_post_screen.dart';
import '../CreateStory/add_story_screen.dart';
import '../notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    final users = context.watch<List<UserModel>?>();
    final ghostProvider = context.watch<DashboardProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
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
        leading: const GhostModeBtn(),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CreatePostScreen());
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
        // shrinkWrap: true,
        children: [
          SizedBox(
            height: 77.h,
            child: Consumer<List<Story>?>(
              builder: (context, provider, b) {
                if (provider == null) {
                  return Container();
                } else {
                  var filterList = provider
                      .where((element) =>
                          currentUser!.followersIds.contains(element.id) ||
                          currentUser.followingsIds.contains(element.id))
                      .toList();
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
                                  Get.to(() => const AddStoryScreen());
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
                var post = ghostProvider.checkGhostMode
                    ? posts.where((element) => (currentUser!.followersIds
                            .contains(element.creatorId) ||
                        currentUser.followingsIds.contains(element.creatorId) &&
                            element.mediaData.isNotEmpty))
                    : posts
                        .where((element) => element.mediaData.isNotEmpty)
                        .toList();
                List<PostModel> filterList = [];
                for (var p in post) {
                  for (var u in users!) {
                    if (p.creatorId == u.id) {
                      filterList.add(p);
                    }
                  }
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 80.h),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filterList.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: filterList[index],
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
