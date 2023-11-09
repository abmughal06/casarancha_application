import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/forum/create_poll_screen.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/primary_appbar.dart';

class ForumsScreen extends StatelessWidget {
  const ForumsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        Get.to(() => const CreatePostScreen());
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
      body: const Center(
        child: Text(strAlertForum),
      ),
    );
  }
}
