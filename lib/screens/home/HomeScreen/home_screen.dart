import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
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
import '../../../widgets/shared/alert_text.dart';
import '../../../widgets/shared/skeleton.dart';
import '../../dashboard/ghost_mode_btn.dart';
import '../CreatePost/create_post_screen.dart';
import '../CreateStory/add_story_screen.dart';
import '../notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  DataProvider dataProvider = DataProvider();
  @override
  void dispose() {
    // dataProvider.chatListUsers.drain()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    // final users = context.watch<List<UserModel>?>();
    final ghostProvider = context.watch<DashboardProvider>();
    super.build(context);
    return GhostScaffold(
      body: currentUser == null
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
              ),
            )
          : NestedScrollView(
              controller: ghostProvider.scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    // expandedHeight: 120.0,
                    floating: true,
                    snap: true,
                    pinned: false,
                    stretch: true,
                    elevation: 0.2,
                    title: Text(
                      strCasaRanch,
                      style: TextStyle(
                        color: color13F,
                        fontFamily: strFontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                      ),
                    ),
                    leading: const GhostModeBtn(),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Get.to(() => const CreatePostScreen(isForum: false));
                        },
                        icon: Image.asset(
                          imgAddPost,
                        ),
                      ),
                      StreamProvider.value(
                        value: dataProvider.notficationLength(),
                        initialData: null,
                        catchError: (context, error) => null,
                        child: Consumer<List<Notification>?>(
                          builder: (context, notification, b) {
                            if (notification == null) {
                              return IconButton(
                                onPressed: () {
                                  Get.to(() => const NotificationScreen());
                                },
                                icon: SvgPicture.asset(
                                  icNotifyBell,
                                ),
                              );
                            }
                            var count = notification.length.toString();
                            return IconButton(
                              onPressed: () {
                                Get.to(() => const NotificationScreen());
                              },
                              icon: Badge(
                                label: Text(count),
                                isLabelVisible: notification.isNotEmpty,
                                child: SvgPicture.asset(
                                  icNotifyBell,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    backgroundColor: Colors.grey.shade50,
                    bottom: PreferredSize(
                      preferredSize:
                          Size.fromHeight(innerBoxIsScrolled ? 5 : 70),
                      child: Visibility(
                        visible: !innerBoxIsScrolled,
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 70),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StreamProvider.value(
                                value: DataProvider().myStory(),
                                initialData: null,
                                catchError: (context, error) => null,
                                child: Consumer<Story?>(
                                  builder: (context, value, child) {
                                    if (value == null) {
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
                                    }
                                    return MyStoryWidget(
                                      stories: value,
                                    );
                                  },
                                ),
                              ),
                              StreamProvider.value(
                                initialData: null,
                                value: DataProvider().allStories(
                                    currentUser.followersIds +
                                        currentUser.followingsIds),
                                catchError: (context, error) => null,
                                child: Consumer<List<Story>?>(
                                    builder: (context, stories, b) {
                                  if (stories == null) {
                                    return Container();
                                  }
                                  return Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      itemCount: stories.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        var storyList = [];
                                        final twentyFourHoursAgo =
                                            DateTime.now().subtract(
                                                const Duration(hours: 24));
                                        DateTime givenDate = DateTime.now();

                                        for (int i = 0;
                                            i <
                                                stories[index]
                                                    .mediaDetailsList
                                                    .length;
                                            i++) {
                                          givenDate = DateTime.parse(
                                              stories[index]
                                                  .mediaDetailsList[i]
                                                  .id);
                                          if (givenDate
                                              .isAfter(twentyFourHoursAgo)) {
                                            storyList.add(stories[index]);
                                          }
                                        }
                                        if (storyList
                                            .contains(stories[index])) {
                                          return AppUserStoryWidget(
                                            story: stories[index],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
              body: StreamProvider.value(
                value: ghostProvider.checkGhostMode
                    ? DataProvider().ghostModePosts(
                        currentUser.followingsIds,
                        currentUser.followersIds,
                        currentUser.id,
                      )
                    : DataProvider().posts(),
                initialData: null,
                catchError: (context, error) => null,
                child: Consumer<List<PostModel>?>(
                  builder: (context, posts, b) {
                    if (posts == null) {
                      return const PostSkeleton();
                    }
                    var filterPosts = posts
                        .where((element) =>
                            !element.isForumPost && !element.isGhostPost)
                        .toList();

                    if (filterPosts.isEmpty) {
                      return const AlertText(
                        text: strAlertPost,
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 80.h),
                      key: const PageStorageKey(0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filterPosts.length,
                      cacheExtent: 100,
                      itemBuilder: (context, index) {
                        return PostCard(
                          post: filterPosts[index],
                          postCreatorId: filterPosts[index].creatorId,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
