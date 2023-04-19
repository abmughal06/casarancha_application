import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/view_post_screen.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/music_player_url.dart';

import 'package:casarancha/widgets/text_widget.dart';
import 'package:casarancha/widgets/video_player_Url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../models/media_details.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.postCardController,
  }) : super(key: key);

  final PostCardController postCardController;
  List<Widget> buildPostType({BoxFit? fit}) {
    final List<Widget> widgetList = [];
    for (var element in postCardController.post.value.mediaData) {
      int pageindex = postCardController.post.value.mediaData.indexOf(element);
      switch (element.type) {
        case 'Qoute':
          widgetList.add(
            InkWell(
              onTap: () => goToViewPostCardScreen(pageindex),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: AutoSizeText(
                      element.link,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          break;
        case 'Photo':
          widgetList.add(InkWell(
            onTap: () => goToViewPostCardScreen(pageindex),
            child: CachedNetworkImage(
              fit: fit ?? BoxFit.cover,
              imageUrl: element.link,
              height: double.tryParse(element.imageHeight ?? ""),
              width: double.tryParse(element.imageWidth ?? ""),
              placeholder: (context, url) => shimmerImg(),
              errorWidget: (context, url, error) => Center(
                child: Text(
                  error.toString(),
                ),
              ),
            ),
          ));
          break;
        case 'Video':
          widgetList.add(InkWell(
            onTap: () => goToViewPostCardScreen(pageindex),
            child: VideoPlayerUrl(
              mediaDetails: element,
              pageIndex: pageindex,
            ),
          ));
          break;
        case 'Music':
          widgetList.add(MusicPlayerUrl(
            musicDetails: element,
            ontap: () => goToViewPostCardScreen(pageindex),
          ));
          break;
        default:
          widgetList.add(Container());
      }
    }
    return widgetList;
  }

  void goToViewPostCardScreen(int pageIndex) => Get.to(() => ViewPostScreen(
        postCardController: postCardController,
        pageIndex: pageIndex,
        widgetList: buildPostType(fit: BoxFit.contain),
      ));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.w,
        horizontal: 20.w,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 2.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: postCreatorTile(postCardController),
          ),
          Container(
            constraints:
                const BoxConstraints(maxWidth: double.infinity, maxHeight: 200),
            color: Colors.grey.shade100,
            child: PageView(
              children: buildPostType(),
            ),
          ),
          heightBox(5.h),
          PostRowButtons(
            postCardController: postCardController,
          ),
          Visibility(
            visible: postCardController.post.value.description != null &&
                postCardController.post.value.description.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10.w,
                right: 10.w,
                left: 10.w,
              ),
              child: TextWidget(
                text: postCardController.post.value.description,
                color: color55F,
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget postCreatorTile(PostCardController postCardController) {
  /* DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await 
    post.value.creatorDetails = CreatorDetails(
        imageUrl: documentSnapshot.data()?['imageStr'],
        name: documentSnapshot.data()?['name'],
        isVerified: documentSnapshot.data()?['isVerified'] ?? false); */
  MediaDetails? mediaDetails = getQuota(postCardController);
  final dateText =
      timeago.format(DateTime.parse(postCardController.post.value.createdAt));
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(postCardController.post.value.creatorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => postCardController.gotoAppUserScreen(
                    postCardController.post.value.creatorId,
                  ),
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Text(snapshot.data?.data()?['name'] ?? "N/A"),
                      widthBox(5.w),
                      if (snapshot.data?.data()?['isVerified'] ?? false)
                        SvgPicture.asset(icVerifyBadge),
                    ],
                  ),
                  subtitle: postCardController.post.value.showPostTime
                      ? TextWidget(
                          text: dateText +
                              ((postCardController.post.value.locationName ==
                                          null ||
                                      postCardController
                                          .post.value.locationName.isEmpty)
                                  ? ""
                                  : " at ${postCardController.post.value.locationName}"),
                          color: color55F,
                          fontSize: 11.sp,
                          textOverflow: TextOverflow.ellipsis,
                        )
                      : null,
                  leading: snapshot.data?.data()?['imageStr'] != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipOval(
                                  child: FadeInImage(
                                      fit: BoxFit.cover,
                                      placeholder:
                                          const AssetImage(imgUserPlaceHolder),
                                      image: NetworkImage(snapshot.data
                                          ?.data()?['imageStr'])))),
                        )
                      : null,
                ),
                mediaDetails != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ReadMoreText(mediaDetails.link,
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            trimExpandedText: " Show less",
                            trimCollapsedText: "Read more",
                            style: const TextStyle(
                              fontSize: 13,
                            )),
                      )
                    : const SizedBox(height: 0, width: 0),
              ],
            );
          }
        }
        return Container();
      });
}

MediaDetails? getQuota(PostCardController postCardController) {
  List<MediaDetails> list = postCardController.post.value.mediaData;
  if (list.isNotEmpty) {
    bool isOnlyQoute = getIsOnlyQoute(list);
    if (!isOnlyQoute) {
      List<MediaDetails> qouteList = list
          .where((element) => element.type.toLowerCase() == "qoute")
          .toList();
      return qouteList.isNotEmpty ? qouteList.first : null;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

class PostRowButtons extends StatelessWidget {
  const PostRowButtons({
    Key? key,
    required this.postCardController,
  }) : super(key: key);

  final PostCardController postCardController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {},
          icon: Obx(
            () => Icon(
              Icons.thumb_up_alt_rounded,
              color:
                  postCardController.isLiked.value ? Colors.red : Colors.grey,
            ),
          ),
        ),
        widthBox(2.5.w),
        Obx(
          () => TextWidget(
            text: '${postCardController.post.value.likesIds.length}',
            color: color221,
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
          ),
        ),
        widthBox(10.w),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: null,
          icon: SvgPicture.asset(
            icCommentPost,
            color: Colors.grey,
          ),
        ),
        widthBox(2.5.w),
        Obx(
          () => TextWidget(
            text: '${postCardController.post.value.commentIds.length}',
            color: color221,
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
          ),
        ),
        widthBox(10.w),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {},
          icon: const Icon(
            Icons.share_rounded,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: postCardController.savePost,
          icon: Obx(() => SvgPicture.asset(
                postCardController.isSaved.value ? icSavedPost : icBookMarkReg,
              )),
        ),
      ],
    );
  }
}

class NewPostCard extends StatefulWidget {
  NewPostCard({
    Key? key,
    required this.postCardController,
    this.videoPlayerController,
  }) : super(key: key);
  VideoPlayerController? videoPlayerController;
  final PostCardController postCardController;
  @override
  State<NewPostCard> createState() => _NewPostCardState();
}

class _NewPostCardState extends State<NewPostCard>
    with AutomaticKeepAliveClientMixin {
  bool get isOnlyQoute =>
      getIsOnlyQoute(widget.postCardController.post.value.mediaData);
  late PageController _pageController;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {});
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.w,
        // horizontal: 20.w,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: postCreatorTile(widget.postCardController)),
          InViewNotifierWidget(
              id: widget.postCardController.post.value.id,
              builder: (context, isInView, child) {
                return Container(
                  color: Colors.grey.shade100,
                  child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: PageView(
                        controller: _pageController,
                        children: setContainer(
                                pageController: _pageController,
                                isPlay: isInView)
                            .where((e) => e != null)
                            .map((e) => e!)
                            .toList(),
                      )),
                );
              }),
          heightBox(5.h),
          PostRowButtons(
            postCardController: widget.postCardController,
          ),
          Visibility(
            visible:
                widget.postCardController.post.value.description.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10.w,
                right: 10.w,
                left: 10.w,
              ),
              child: TextWidget(
                text: widget.postCardController.post.value.description,
                color: color55F,
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget?> setContainer(
      {BoxFit boxFit = BoxFit.cover,
      PageController? pageController,
      bool isPlay = false}) {
    ScrollController scrollController = ScrollController();

    List<MediaDetails> mediadata =
        widget.postCardController.post.value.mediaData;

    return mediadata.map((element) {
      int pageindex = mediadata.indexOf(element);

      return (element.type.toLowerCase() == "qoute" && isOnlyQoute)
          ? qoute(scrollController, element.link, pageindex)
          : (element.type.toLowerCase() == "photo")
              ? InkWell(
                  onTap: () =>
                      goToViewPostCardScreen(pageindex, boxFit: BoxFit.contain),
                  child: FadeInImage(
                    fit: boxFit,
                    image: NetworkImage(element.link),
                    placeholder: const AssetImage(imgImagePlaceHolder),
                  ),
                )
              : (element.type.toLowerCase() == "video")
                  ? InkWell(
                      onTap: () => goToViewPostCardScreen(pageindex,
                          boxFit: BoxFit.contain),
                      child: VideoPlayerUrl(
                        key: Key(element.id),
                        mediaDetails: element,
                        pageIndex: pageindex,
                        pageController: pageController,
                      ),
                    )
                  : (element.type.toLowerCase() == "music")
                      ? MusicPlayerUrl(
                          musicDetails: element,
                          ontap: () => goToViewPostCardScreen(pageindex))
                      : null;
    }).toList();
  }

  void goToViewPostCardScreen(int pageIndex, {BoxFit boxFit = BoxFit.cover}) =>
      Get.to(
        () => ViewPostScreen(
            postCardController: widget.postCardController,
            pageIndex: pageIndex,
            isAspectContainer: isOnlyQoute,
            widgetList: setContainer(
              boxFit: boxFit,
            )
                .where((e) => e != null)
                .map((e) => e!)
                .toList() /*  buildPostType(fit: BoxFit.contain) */
            ),
      );
  Widget qoute(scrollController, text, pageindex) {
    return InkWell(
      onTap: () => goToViewPostCardScreen(pageindex, boxFit: BoxFit.contain),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RawScrollbar(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            thumbColor: Colors.red.withOpacity(0.5),
            controller: scrollController,
            child: text.length < 400
                ? AutoSizeText(
                    text,
                    style: const TextStyle(fontSize: 22),
                  )
                : SingleChildScrollView(
                    controller: scrollController,
                    child: ReadMoreText(
                      text,
                      trimLength: 400,
                      trimExpandedText: " Show less",
                      trimCollapsedText: "Read more",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

bool getIsOnlyQoute(List<MediaDetails> mediadata) {
  List<String> types = [];
  types.addAll(mediadata
      .where((element) => element.type.toLowerCase() != "qoute")
      .map((e) => e.type));

  return types.isEmpty;
}
