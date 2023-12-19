import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/screens/forum/create_poll_screen.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_card.dart';
import 'package:casarancha/widgets/shared/alert_text.dart';
import 'package:casarancha/widgets/shared/skeleton.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../widgets/primary_appbar.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen>
    with AutomaticKeepAliveClientMixin<ForumsScreen> {
  @override
  Widget build(BuildContext context) {
    final ghostProvider = context.watch<DashboardProvider>();

    super.build(context);

    return GhostScaffold(
      appBar: primaryAppbar(
        title: strForum,
        elevation: 0.1,
        leading: const GhostModeBtn(),
        actions: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();
                        Get.to(() => const CreatePostScreen(isForum: true));
                      },
                      child: const TextWidget(text: 'Upload Post'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();
                        Get.to(() => const CreatePollScreen());
                      },
                      child: const TextWidget(text: 'Upload Poll'),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: StreamProvider.value(
        value: DataProvider().forums(),
        initialData: null,
        child: Consumer<List<PostModel>?>(builder: (context, posts, b) {
          if (posts == null) {
            return const PostSkeleton();
          }
          return ListView(
            controller: ghostProvider.forumScrollController,
            key: const PageStorageKey(1),
            children: [
              ListView.builder(
                  itemCount: posts.length,
                  padding: EdgeInsets.only(
                    bottom: 100.h,
                    top: 15,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    if (posts.isEmpty) {
                      return const AlertText(
                          text: 'Forums does not have any posts yet');
                    }

                    return StreamProvider.value(
                      value: DataProvider().getSingleUser(post.creatorId),
                      initialData: null,
                      child:
                          Consumer<UserModel?>(builder: (context, appUser, b) {
                        if (appUser == null) {
                          return const PostSkeleton();
                        }
                        return PostCard(post: post, postCreator: appUser);
                      }),
                    );
                  }),
            ],
          );
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
