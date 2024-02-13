import 'package:casarancha/models/providers/user_data_provider.dart';
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
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../widgets/primary_appbar.dart';

class ForumsScreen extends StatelessWidget {
  const ForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ghostProvider = context.watch<DashboardProvider>();

    return GhostScaffold(
      appBar: primaryAppbar(
        title: appText(context).strForum,
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
                      child: TextWidget(text: appText(context).uploadPost),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();
                        Get.to(() => const CreatePollScreen());
                      },
                      child: TextWidget(text: appText(context).uploadPoll),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(appText(context).strCancel),
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
          return ListView.builder(
            key: const PageStorageKey(1),
            itemCount: posts.length,
            controller: ghostProvider.forumScrollController,
            padding: const EdgeInsets.only(top: 10, bottom: 100),
            itemBuilder: (context, index) {
              if (posts.isEmpty) {
                return AlertText(text: appText(context).alertForum);
              }
              var post = posts[index];

              return PostCard(post: post, postCreatorId: post.creatorId);
            },
          );
        }),
      ),
    );
  }
}
