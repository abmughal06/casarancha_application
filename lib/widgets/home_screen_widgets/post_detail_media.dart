import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/common_widgets.dart';
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
import '../music_player_url.dart';
import '../text_widget.dart';
import '../video_player_url.dart';

class CheckMediaAndShowPost extends StatelessWidget {
  const CheckMediaAndShowPost({
    Key? key,
    required this.mediaData,
    required this.postId,
    this.iniializedFuturePlay,
    required this.ondoubleTap,
    required this.postModel,
    required this.isPostDetail,
    this.isFullScreen = false,
  }) : super(key: key);

  final MediaDetails mediaData;
  final PostModel postModel;
  final Future<void>? iniializedFuturePlay;
  final String postId;
  final VoidCallback ondoubleTap;
  final bool isPostDetail;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    switch (mediaData.type) {
      case "Photo":
        return InkWell(
          onDoubleTap: ondoubleTap,
          onTap: isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: postModel, isPostDetail: isPostDetail))
              : () => Get.to(() => PostDetailScreen(postModel: postModel)),
          child: CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => Center(
                    child: SizedBox(
                      height: 30.h,
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                  ),
              imageUrl: mediaData.link),
        );

      case "Video":
        return InkWell(
          onDoubleTap: ondoubleTap,
          onTap: isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: postModel, isPostDetail: isPostDetail))
              : () => Get.to(() => PostDetailScreen(postModel: postModel)),
          child: FutureBuilder(
              future: iniializedFuturePlay,
              builder: (context, snapshot) {
                return VideoPlayerWidget(
                  videoUrl: mediaData.link,
                  postModel: postModel,
                );
              }),
        );
      case "Music":
        return InkWell(
          onDoubleTap: ondoubleTap,
          onTap: isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: postModel, isPostDetail: isPostDetail))
              : () => Get.to(() => PostDetailScreen(postModel: postModel)),
          child: MusicPlayerUrl(
            border: 0,
            musicDetails: mediaData,
            ontap: () {},
          ),
        );

      default:
        return InkWell(
          // onDoubleTap: ondoubleTap,
          onTap: isPostDetail
              ? () => Get.to(() => PostFullScreenView(
                  post: postModel, isPostDetail: isPostDetail))
              : () => Get.to(() => PostDetailScreen(postModel: postModel)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: isPostDetail ? 20 : 15,
              right: isPostDetail ? 20 : 15,
              top: isPostDetail ? 110 : 10,
              bottom: 20,
            ),
            child: SingleChildScrollView(
              child: TextWidget(
                text: mediaData.link,
                textAlign: isFullScreen ? TextAlign.center : TextAlign.left,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: isFullScreen ? colorFF3 : color221,
              ),
            ),
          ),
        );
    }
  }
}

class PostMediaWidget extends StatelessWidget {
  const PostMediaWidget(
      {Key? key,
      required this.post,
      required this.isPostDetail,
      this.isFullScreen = false})
      : super(key: key);

  final PostModel post;
  final bool isPostDetail;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<PostProvider>(context);
    return CarouselSlider(
      items: post.mediaData
          .map(
            (e) => CheckMediaAndShowPost(
              isPostDetail: isPostDetail,
              postModel: post,
              ondoubleTap: () => prov.toggleLikeDislike(postModel: post),
              mediaData: e,
              postId: post.id,
              isFullScreen: isFullScreen,
            ),
          )
          .toList(),
      options: CarouselOptions(
        aspectRatio: post.mediaData[0].type == 'Qoute'
            ? isPostDetail
                ? 1 / 1
                : 16 / 9
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
      {Key? key, required this.post, required this.isPostDetail})
      : super(key: key);
  final PostModel post;
  final bool isPostDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Visibility(
            visible: post.creatorId == FirebaseAuth.instance.currentUser!.uid,
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
                height: 30.h,
                width: 30.h,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: SvgPicture.asset(icThreeDots),
              ),
            ),
          ),
          widthBox(12.w)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: PostMediaWidget(
          isPostDetail: isPostDetail,
          post: post,
          isFullScreen: true,
        ),
      ),
    );
  }
}
