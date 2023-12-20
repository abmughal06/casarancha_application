import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_card.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/shared/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GhostPosts extends StatefulWidget {
  const GhostPosts({super.key});

  @override
  State<GhostPosts> createState() => _GhostPostsState();
}

class _GhostPostsState extends State<GhostPosts>
    with AutomaticKeepAliveClientMixin<GhostPosts> {
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final users = context.watch<List<UserModel>?>();

    super.build(context);
    return GhostScaffold(
      appBar: primaryAppbar(title: 'Ghost Posts'),
      body: Stack(
        children: [
          StreamProvider.value(
            value: DataProvider().ghostPosts(),
            initialData: null,
            child: Consumer<List<PostModel>?>(
              builder: (context, posts, child) {
                if (posts == null || users == null) {
                  return const PostSkeleton();
                }
                return ListView(
                  controller: dashboardProvider.ghostPostScrollController,
                  children: [
                    ListView.builder(
                      itemCount: posts.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10, bottom: 100),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (co, index) {
                        return PostCard(
                          isGhostPost: posts[index].isGhostPost,
                          post: posts[index],
                          postCreator: users
                              .where((element) =>
                                  element.id == posts[index].creatorId)
                              .first,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            right: 20.w,
            bottom: 90.h,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const CreatePostScreen(isGhostPost: true));
              },
              child: Container(
                padding: EdgeInsets.all(8.h),
                decoration: const BoxDecoration(
                    color: colorPrimaryA05, shape: BoxShape.circle),
                child: Icon(
                  Icons.add,
                  size: 27.sp,
                  color: colorWhite,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
