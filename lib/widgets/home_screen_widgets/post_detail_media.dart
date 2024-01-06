import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/media_details.dart';
import '../../models/post_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/dashboard/provider/download_provider.dart';
import '../music_player_url.dart';
import '../poll.dart';
import '../text_widget.dart';
import '../video_player.dart';

class CheckMediaAndShowPost extends StatefulWidget {
  const CheckMediaAndShowPost({
    super.key,
    required this.mediaData,
    required this.postId,
    required this.ondoubleTap,
    required this.postModel,
    required this.isPostDetail,
    this.isFullScreen = false,
    required this.groupId,
  });

  final MediaDetails mediaData;
  final PostModel postModel;
  final String postId;
  final VoidCallback ondoubleTap;
  final bool isPostDetail;
  final bool isFullScreen;
  final String? groupId;

  @override
  State<CheckMediaAndShowPost> createState() => _CheckMediaAndShowPostState();
}

class _CheckMediaAndShowPostState extends State<CheckMediaAndShowPost> {
  late Future<void> initializedFuturePlay;

  @override
  void initState() {
    super.initState();

    initializedFuturePlay = Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    switch (widget.mediaData.type) {
      case "Photo":
        postProvider.countVideoViews(
          postModel: widget.postModel,
          groupId: widget.groupId,
        );
        return InkWell(
          onDoubleTap: widget.ondoubleTap,
          onLongPress: () {
            widget.isPostDetail
                ? showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDownloadDialog(
                        url: widget.mediaData.link,
                        path:
                            '${widget.mediaData.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(widget.mediaData.type)}',
                      );
                    })
                : null;
          },
          onTap: widget.isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: widget.postModel, isPostDetail: widget.isPostDetail))
              : () => Get.to(() => PostDetailScreen(
                    postModel: widget.postModel,
                    groupId: widget.groupId,
                  )),
          child: CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Container(
              color: colorBlack.withOpacity(0.04),
              // width: MediaQuery.of(context).size.width,
              // height: double.parse(mediaData.imageHeight!),
            ),
            imageUrl: widget.mediaData.link,
          ),
        );

      case "Video":
        return InkWell(
          onLongPress: () {
            widget.isPostDetail
                ? showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDownloadDialog(
                        url: widget.mediaData.link,
                        path:
                            '${widget.mediaData.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(widget.mediaData.type)}',
                      );
                    })
                : null;
          },
          onDoubleTap: widget.ondoubleTap,
          onTap: widget.isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: widget.postModel, isPostDetail: widget.isPostDetail))
              : () => Get.to(() => PostDetailScreen(
                    postModel: widget.postModel,
                    groupId: widget.groupId,
                  )),
          child: FutureBuilder(
              future: initializedFuturePlay,
              builder: (context, snapshot) {
                return VideoPlayerWidget(
                  key: ValueKey(widget.mediaData.link),
                  media: widget.mediaData,
                  videoUrl: widget.mediaData.link,
                  postModel: widget.postModel,
                  isPostDetailScreen:
                      widget.isFullScreen ? false : widget.isPostDetail,
                );
              }),
        );
      case "Music":
        return InkWell(
          key: ValueKey(widget.postModel.mediaData.first.link),
          onDoubleTap: widget.ondoubleTap,
          child: MusicPlayerUrl(
            key: ValueKey(widget.postModel.mediaData.first.link),
            postModel: widget.postModel,
            border: 0,
            musicDetails: widget.mediaData,
            ontap: () {},
            isPostDetail: widget.isPostDetail,
          ),
        );

      case 'poll':
        return Container(
            // height: 200,
            // width: MediaQuery.of(context).size.width,
            padding: widget.isPostDetail
                ? EdgeInsets.only(
                    top: 100.h, left: 12.h, right: 12.h, bottom: 12.h)
                : EdgeInsets.all(12.h),
            child: Poll(postModel: widget.postModel));

      default:
        postProvider.countVideoViews(
            postModel: widget.postModel, groupId: widget.groupId);
        return InkWell(
          onTap: widget.isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: widget.postModel, isPostDetail: widget.isPostDetail))
              : () => Get.to(() => PostDetailScreen(
                    postModel: widget.postModel,
                    groupId: widget.groupId,
                  )),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: widget.isPostDetail ? 20 : 15,
              right: widget.isPostDetail ? 20 : 15,
              top: widget.isPostDetail ? 130 : 15,
              bottom: 20,
            ),
            child: SingleChildScrollView(
              child: SelectableTextWidget(
                text: widget.mediaData.link,
                textAlign:
                    widget.isFullScreen ? TextAlign.center : TextAlign.left,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: widget.isFullScreen ? colorFF3 : color221,
              ),
            ),
          ),
        );
    }
  }
}

double getQouteAspectRatio(String text, bool isPostDetail) {
  if (isPostDetail) {
    if (text.length > 400) {
      return 9 / 13;
    } else {
      return 1 / 1;
    }
  } else {
    if (text.length > 400) {
      return 9 / 13;
    } else {
      return 17 / 9;
    }
  }
}

class PostMediaWidget extends StatefulWidget {
  const PostMediaWidget({
    super.key,
    required this.post,
    required this.isPostDetail,
    this.isFullScreen = false,
    required this.groupId,
  });

  final PostModel post;
  final bool isPostDetail;
  final bool isFullScreen;
  final String? groupId;

  @override
  State<PostMediaWidget> createState() => _PostMediaWidgetState();
}

class _PostMediaWidgetState extends State<PostMediaWidget> {
  final PageController postPageController = PageController();
  int postCurrentPageIndex = 0;
  late double videoAspectRatio;

  changeIndex(v) {
    if (mounted) {
      setState(() {
        postCurrentPageIndex = v;
        postPageController.jumpToPage(postCurrentPageIndex);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getVideoAspectRatio(widget.post.mediaData.first.link);

    postCurrentPageIndex = 0;
  }

  getVideoAspectRatio(url) async {
    if (widget.post.mediaData.first.type == 'Video') {
      final video = VideoPlayerController.networkUrl(Uri.parse(url));
      videoAspectRatio =
          await video.initialize().then((value) => video.value.aspectRatio);
    } else {
      videoAspectRatio = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<PostProvider>(context);
    if (widget.post.mediaData.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 500,
        child: Center(
          child: Text('Post is deleted'),
        ),
      );
    }
    return ExpandablePageView.builder(
      itemCount: widget.post.mediaData.length,
      controller: postPageController,
      // estimatedPageSize: 400,
      onPageChanged: (value) {
        if (mounted) {
          setState(() {
            postCurrentPageIndex = value;
          });
        }
      },
      itemBuilder: (context, index) {
        var media = widget.post.mediaData[index];
        return Stack(
          fit: StackFit.loose,
          children: [
            Visibility(
              visible: media.type == 'Photo' ||
                  media.type == 'Video' ||
                  media.type == 'Music',
              child: AspectRatio(
                aspectRatio: media.type == 'Photo'
                    ? double.parse(media.imageWidth!) /
                        double.parse(media.imageHeight!)
                    : media.type == 'Video'
                        ? double.parse(media.videoAspectRatio!)
                        : MediaQuery.of(context).size.width / 200,
                child: CheckMediaAndShowPost(
                  groupId: widget.groupId,
                  isPostDetail: widget.isPostDetail,
                  postModel: widget.post,
                  ondoubleTap: () => prov.toggleLikeDislike(
                      postModel: widget.post, groupId: widget.groupId),
                  mediaData: media,
                  postId: widget.post.id,
                  isFullScreen: widget.isFullScreen,
                ),
              ),
            ),
            Visibility(
              visible: media.type == 'Qoute' || media.type == 'poll',
              child: CheckMediaAndShowPost(
                groupId: widget.groupId,
                isPostDetail: widget.isPostDetail,
                postModel: widget.post,
                ondoubleTap: () => prov.toggleLikeDislike(
                    postModel: widget.post, groupId: widget.groupId),
                mediaData: media,
                postId: widget.post.id,
                isFullScreen: widget.isFullScreen,
              ),
            ),
            Visibility(
              visible: widget.post.mediaData.length > 1,
              child: Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List.generate(widget.post.mediaData.length, (index) {
                    return InkWell(
                      onTap: () {
                        changeIndex(index);
                      },
                      child: Container(
                        height: 8.h,
                        width: 8.h,
                        margin: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: postCurrentPageIndex == index
                              ? colorFF7
                              : colorDD9.withOpacity(0.3),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PostFullScreenView extends StatelessWidget {
  const PostFullScreenView({
    super.key,
    required this.post,
    required this.isPostDetail,
    this.groupId,
  });
  final PostModel post;
  final bool isPostDetail;
  final String? groupId;
  // final MediaDetails media;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: PostMediaWidget(
                groupId: groupId,
                isPostDetail: isPostDetail,
                post: post,
                isFullScreen: true,
              ),
            ),
            Positioned(
              right: 20,
              top: 30,
              child: Visibility(
                visible:
                    post.creatorId == FirebaseAuth.instance.currentUser!.uid,
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        decoration: const BoxDecoration(color: Colors.red),
                        height: 80,
                        child: InkWell(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection("posts")
                                .doc(post.id)
                                .delete()
                                .then((value) => Get.back())
                                .whenComplete(() => Get.back());
                          },
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
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.more_horiz,
                      color: colorBlack,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 35,
              child: InkWell(
                onTap: () => Get.back(),
                child: SvgPicture.asset(
                  icIosBackArrow,
                  height: 30,
                  color: colorWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
