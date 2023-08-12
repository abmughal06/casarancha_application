import 'dart:io';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_detail_media.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_footer.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_header.dart';
import 'package:casarancha/widgets/home_screen_widgets/report_sheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../screens/dashboard/provider/dashboard_provider.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {Key? key,
      required this.post,
      this.initializedFuturePlay,
      required this.postCreator})
      : super(key: key);

  final PostModel post;
  final Future<void>? initializedFuturePlay;
  final UserModel postCreator;

  @override
  Widget build(BuildContext context) {
    final curruentUser = context.watch<UserModel?>();
    final postPorvider = Provider.of<PostProvider>(context, listen: false);
    final ghostProvider = context.watch<DashboardProvider>();
    final download = context.watch<DownloadProvider>();
    return Column(
      children: [
        CustomPostHeader(
          postCreator: postCreator,
          postModel: post,
          onVertItemClick: () {
            Get.back();

            if (post.creatorId == curruentUser!.id) {
              Get.bottomSheet(
                Container(
                  decoration: const BoxDecoration(color: Colors.red),
                  height: 80,
                  child: InkWell(
                    onTap: () => postPorvider.deletePost(postModel: post),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: "Delete Post",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                isScrollControlled: true,
              );
            } else {
              Get.bottomSheet(
                BottomSheetWidget(
                  ontapBlock: () {},
                  onTapDownload: () async {
                    download.startDownloading(post.mediaData.first.link,
                        '${post.mediaData.first.link.split('/').last}${checkMediaTypeAndSetExtention(post.mediaData.first.type)}');
                    Get.back();
                    Get.bottomSheet(const DownloadProgressContainer());
                  },
                ),
                isScrollControlled: true,
              );
            }
          },
          ontap: () {},
          headerOnTap: () {
            navigateToAppUserScreen(post.creatorId, context);
          },
        ),
        PostMediaWidget(post: post, isPostDetail: false),
        heightBox(10.h),
        CustomPostFooter(
          isLike: post.likesIds.contains(curruentUser!.id),
          ontapLike: () {
            ghostProvider.checkGhostMode
                ? GlobalSnackBar.show(message: "Ghost Mode is enabled")
                : postPorvider.toggleLikeDislike(
                    postModel: post,
                  );
          },
          ontapSave: () {
            ghostProvider.checkGhostMode
                ? GlobalSnackBar.show(message: "Ghost Mode is enabled")
                : postPorvider.onTapSave(
                    userModel: curruentUser, postId: post.id);
          },
          postModel: post,
          savepostIds: curruentUser.savedPostsIds,
        ),
      ],
    );
  }
}

String checkMediaTypeAndSetExtention(String media) {
  switch (media) {
    case 'Photo':
      return '.jpg';
    case 'Video':
      return '.MOV';
    case 'Music':
      return '.mp3';
    default:
      return '';
  }
}

class DownloadProvider extends ChangeNotifier {
  Dio dio = Dio();
  double progress = 0.0;
  bool isDownloading = false;
  File? filePath;

  void startDownloading(String url, String filename) async {
    isDownloading = true;
    notifyListeners();
    try {
      String path = await _getPath(filename);

      await dio.download(
        url,
        path,
        onReceiveProgress: (count, total) {
          progress = count / total;
          notifyListeners();
        },
        deleteOnError: true,
      );
    } catch (e) {
      isDownloading = false;
      notifyListeners();
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }

  Future<String> _getPath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$filename';
  }
}

class DownloadProgressContainer extends StatelessWidget {
  const DownloadProgressContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(
      builder: (context, d, b) {
        return Container(
          height: 200.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 65),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      d.isDownloading == false
                          ? const Icon(Icons.done)
                          : centerLoader(),
                      heightBox(12.h),
                      TextWidget(
                        text:
                            'Downloading file (${(d.progress * 100).toInt()}%)',
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 25.w,
                top: 20.h,
                child: d.isDownloading == false
                    ? InkWell(
                        onTap: () {
                          Get.back();
                          d.progress = 0.0;
                        },
                        child: const Icon(Icons.close),
                      )
                    : Container(),
              )
            ],
          ),
        );
      },
    );
  }
}
