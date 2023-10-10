import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/media_details.dart';
import '../../models/post_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/dashboard/provider/download_provider.dart';
import '../music_player_url.dart';
import '../text_widget.dart';
import '../video_player.dart';

class CheckMediaAndShowPost extends StatelessWidget {
  const CheckMediaAndShowPost({
    Key? key,
    required this.mediaData,
    required this.postId,
    required this.ondoubleTap,
    required this.postModel,
    required this.isPostDetail,
    this.isFullScreen = false,
    required this.groupId,
  }) : super(key: key);

  final MediaDetails mediaData;
  final PostModel postModel;
  final String postId;
  final VoidCallback ondoubleTap;
  final bool isPostDetail;
  final bool isFullScreen;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    switch (mediaData.type) {
      case "Photo":
        postProvider.countVideoViews(
          postModel: postModel,
          groupId: groupId,
        );
        return InkWell(
          onDoubleTap: ondoubleTap,
          onLongPress: () {
            isPostDetail
                ? showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDownloadDialog(
                        url: mediaData.link,
                        path:
                            '${mediaData.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(mediaData.type)}',
                      );
                    })
                : null;
          },
          onTap: isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: postModel, isPostDetail: isPostDetail))
              : () => Get.to(() => PostDetailScreen(
                    postModel: postModel,
                    groupId: groupId,
                  )),
          child: CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => Center(
                    child: SizedBox(
                      height: 30.h,
                      width: 30.h,
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                  ),
              imageUrl: mediaData.link),
        );

      case "Video":
        return InkWell(
          onLongPress: () {
            isPostDetail
                ? showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDownloadDialog(
                        url: mediaData.link,
                        path:
                            '${mediaData.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(mediaData.type)}',
                      );
                    })
                : null;
          },
          onDoubleTap: ondoubleTap,
          onTap: isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: postModel, isPostDetail: isPostDetail))
              : () => Get.to(() => PostDetailScreen(
                    postModel: postModel,
                    groupId: groupId,
                  )),
          child: VideoPlayerWidget(
            key: ValueKey(mediaData.link),
            videoUrl: mediaData.link,
            postModel: postModel,
            isPostDetailScreen: isFullScreen ? false : isPostDetail,
          ),
        );
      case "Music":
        return InkWell(
          onDoubleTap: ondoubleTap,
          child: MusicPlayerUrl(
            key: ValueKey(postModel.mediaData.first.link),
            postModel: postModel,
            border: 0,
            musicDetails: mediaData,
            ontap: () {},
            isPostDetail: isPostDetail,
          ),
        );

      default:
        postProvider.countVideoViews(postModel: postModel, groupId: groupId);
        return InkWell(
          onTap: isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: postModel, isPostDetail: isPostDetail))
              : () => Get.to(() => PostDetailScreen(
                    postModel: postModel,
                    groupId: groupId,
                  )),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: isPostDetail ? 20 : 15,
              right: isPostDetail ? 20 : 15,
              top: isPostDetail ? 110 : 10,
              bottom: 20,
            ),
            child: SingleChildScrollView(
              child: SelectableTextWidget(
                text: mediaData.link,
                textAlign: isFullScreen ? TextAlign.center : TextAlign.left,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: isFullScreen ? colorFF3 : color221,
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

class PostMediaWidget extends StatelessWidget {
  const PostMediaWidget(
      {Key? key,
      required this.post,
      required this.isPostDetail,
      this.isFullScreen = false,
      required this.groupId})
      : super(key: key);

  final PostModel post;
  final bool isPostDetail;
  final bool isFullScreen;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<PostProvider>(context);
    return CarouselSlider(
      items: post.mediaData
          .map(
            (e) => Stack(
              children: [
                CheckMediaAndShowPost(
                  groupId: groupId,
                  isPostDetail: isPostDetail,
                  postModel: post,
                  ondoubleTap: () => prov.toggleLikeDislike(postModel: post),
                  mediaData: e,
                  postId: post.id,
                  isFullScreen: isFullScreen,
                ),
                Visibility(
                  visible: post.mediaData.length > 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: post.mediaData
                            .map(
                              (i) => Container(
                                height: 8.h,
                                width: 8.h,
                                margin: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i.id != e.id
                                      ? colorDD9.withOpacity(0.3)
                                      : colorFF7,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
          .toList(),
      options: CarouselOptions(
        aspectRatio: post.mediaData[0].type == 'Qoute'
            ? getQouteAspectRatio(post.mediaData[0].link, isPostDetail)
            : post.mediaData[0].type == 'Music'
                ? 13 / 9
                : post.mediaData[0].type == 'Photo'
                    ? double.parse(post.mediaData[0].imageWidth!) /
                        double.parse(post.mediaData[0].imageHeight!)
                    : 9 / 16,
        viewportFraction: 1,
        enableInfiniteScroll: false,
      ),
    );
  }
}

class PostFullScreenView extends StatelessWidget {
  const PostFullScreenView(
      {Key? key, required this.post, required this.isPostDetail, this.groupId})
      : super(key: key);
  final PostModel post;
  final bool isPostDetail;
  final String? groupId;

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
