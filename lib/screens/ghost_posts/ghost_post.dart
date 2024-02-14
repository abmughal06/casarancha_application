import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_card.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/shared/skeleton.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GhostPosts extends StatelessWidget {
  const GhostPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    return GhostScaffold(
      appBar: primaryAppbar(
          title: appText(context).strGhostPost, leading: const GhostModeBtn()),
      body: Stack(
        children: [
          StreamProvider.value(
            value: DataProvider().ghostPosts(),
            initialData: null,
            child: Consumer<List<PostModel>?>(
              builder: (context, posts, child) {
                if (posts == null) {
                  return const PostSkeleton();
                }
                return ListView.builder(
                  key: const PageStorageKey(2),
                  itemCount: posts.length,
                  cacheExtent: 100,
                  controller: dashboardProvider.ghostPostScrollController,
                  padding: const EdgeInsets.only(top: 10, bottom: 100),
                  itemBuilder: (co, index) {
                    return PostCard(
                      isGhostPost: posts[index].isGhostPost,
                      post: posts[index],
                      postCreatorId: posts[index].creatorId,
                    );
                  },
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
}
