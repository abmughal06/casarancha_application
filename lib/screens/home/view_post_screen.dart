import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/comment_model.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/PostCard/PostCard.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/menu_post_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';

import '../../widgets/clip_pad_shadow.dart';

import '../../widgets/common_widgets.dart';

import '../../widgets/text_widget.dart';

class ViewPostScreen extends StatefulWidget {
  ViewPostScreen(
      {Key? key,
      required this.postCardController,
      required this.widgetList,
      required this.pageIndex,
      this.isAspectContainer = true})
      : super(key: key);
  final PostCardController postCardController;

  final int pageIndex;
  bool isAspectContainer;
  final List<Widget> widgetList;

  @override
  State<ViewPostScreen> createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  late PageController pageController;
  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 8.w,
        height: 8.h,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.white : Colors.grey,
            shape: BoxShape.circle),
      );
    });
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: widget.pageIndex,
    );
    pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey.shade200,
                width: double.infinity,
                height: widget.isAspectContainer ? 359.h : 260.h,
                child: Stack(
                  children: [
                    PageView(
                      controller: pageController,
                      children: [...widget.widgetList],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: indicators(
                              widget.widgetList.length,
                              pageController.hasClients
                                  ? pageController.page ?? widget.pageIndex
                                  : widget.pageIndex),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: SvgPicture.asset(
                            icLeftArrowVp,
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            height: 35,
                            width: 35,
                            child: menuButton(
                                context, widget.postCardController))),
                  ],
                ),
              ),
            )
          ],
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25.r),
                        bottomLeft: Radius.circular(25.r)),
                    boxShadow: [
                      BoxShadow(
                        color: colorPrimaryA05.withOpacity(.10),
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Colors.grey.shade300,
                      ),
                      BoxShadow(
                        color: Colors.grey.shade300,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PostRowButtons(
                      postCardController: widget.postCardController,
                    ),
                    heightBox(5.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: postCreatorTile(
                        widget.postCardController,
                      ),
                    ),
                    heightBox(5.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextWidget(
                        text: widget.postCardController.post.value.description,
                        color: color55F,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.start,
                        fontSize: 13.sp,
                      ),
                    ),
                    heightBox(10.w),
                  ],
                ),
              ),
              Expanded(
                child: FirestoreListView(
                  query: widget.postCardController.postRef
                      .collection('comments')
                      .orderBy(
                        'createdAt',
                        descending: false,
                      ),
                  itemBuilder: (context,
                      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                    final Comment comment = Comment.fromMap(doc.data());
                    return CommentTile(comment: comment);
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(color: colorWhite, boxShadow: [
                      BoxShadow(
                        color: colorPrimaryA05.withOpacity(.36),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(4, 0),
                      ),
                    ]),
                    child: TextField(
                      controller: widget.postCardController.commentController,
                      style: TextStyle(
                        color: color239,
                        fontSize: 16.sp,
                        fontFamily: strFontName,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: strWriteComment,
                        hintStyle: TextStyle(
                          color: color55F,
                          fontSize: 14.sp,
                          fontFamily: strFontName,
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GestureDetector(
                                onTap: widget.postCardController.commentOnPost,
                                child: Image.asset(
                                  imgSendComment,
                                  height: 38.h,
                                  width: 38.w,
                                ))),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 20.h),
                        focusColor: Colors.transparent,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  const CommentTile({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(comment.creatorDetails.name),
          widthBox(5.w),
          if (comment.creatorDetails.isVerified)
            SvgPicture.asset(icVerifyBadge),
        ],
      ),
      subtitle: TextWidget(
        text: comment.message,
        color: color55F,
        fontSize: 11.sp,
        textOverflow: TextOverflow.ellipsis,
      ),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipOval(
                child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: const AssetImage(imgUserPlaceHolder),
                    image: NetworkImage(comment.creatorDetails.imageUrl)))),
      ),
      // trailing: IconButton(
      //     onPressed: () {},
      //     icon: SvgPicture.asset(
      //       icCardMenu,
      //     )),
    );
  }
}
