import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/resources/color_resources.dart';

import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:video_player/video_player.dart';

import '../resources/image_resources.dart';
import '../resources/localization_text_strings.dart';
import '../utils/app_constants.dart';

import 'common_widgets.dart';

enum PostType { image, video, music, quote }

Widget feedCardPost(
    {required BuildContext context,
    required double width,
    required String imgUserNet,
    required bool isVerify,
    required String userName,
    required String lastSeen,
    required postType,
    required int index,
    required viewModel,
    required Size screenSize,
    String? likeCount,
    String? commentCount,
    String? postDescriptionStr,
    imgUrlPost,
    textQuotaPost,
    required GestureTapCallback onTapSharePost,
    required GestureTapCallback onTapCardMenu,
    GestureTapCallback? onTapPost,
    GestureTapCallback? onTapOtherProfile,
    double? cardMarginHor,
    String? musicUrl,
    // MusicManager? musicManager,
    String? songTitle,
    String? albumTitle,
    VideoPlayerController? videoController,
    Future<void>? initializeVideoPlayerFuture,
    bool? isSavedPost}) {
  if (isSavedPost != null) {
    for (int i = 0; i < viewModel!.isSavedPost.length; i++) {
      viewModel!.isSavedPost[i] = true;
      viewModel!.onTapNotify();
    }
  }

  return Container();
}

Widget likeCmtShareWidget({
  required bool isLikedPost,
  GestureTapCallback? onTapLike,
  onTapComment,
  onTapSharePost,
  String? likeCount,
  commentCount,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      svgImgButton(
          svgIcon: isLikedPost ? icLikeRed : icLikeWhite, onTap: onTapLike),
      widthBox(10.w),
      TextWidget(
        text: likeCount ?? "0",
        color: color221,
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
      ),
      widthBox(17.w),
      svgImgButton(svgIcon: icCommentPost, onTap: onTapComment),
      widthBox(10.w),
      TextWidget(
        text: commentCount ?? "0",
        color: color221,
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
      ),
      widthBox(17.w),
      svgImgButton(svgIcon: icSharePost, onTap: onTapSharePost),
    ],
  );
}

List<String> reportList = [
  "It’s spam",
  "Nudity or sexual activity",
  "I just don’t like it",
  "Scam or fraud",
  "False information",
  "Hate speech or symbols"
];

Widget textMenuItem(
    {required String text, required GestureTapCallback onTap, Color? color}) {
  return GestureDetector(
    onTap: onTap,
    child: TextWidget(
      text: text,
      color: color ?? color13F,
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget reportListWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      heightBox(15.h),
      TextWidget(
        text: strReport,
        color: color13F,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
      heightBox(8.h),
      Text(
        strReportReasonChoose,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color55F,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

Widget reportDoneWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      heightBox(34.h),
      SvgPicture.asset(icReportPostDone),
      heightBox(34.h),
      TextWidget(
        text: strThanksForReport,
        color: color221,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      heightBox(6.h),
      TextWidget(
        text: strSparmReport,
        color: color55F,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      heightBox(69.h),
    ],
  );
}

Widget menuPostWidget(context) {
  return Padding(
    padding: EdgeInsets.only(bottom: 40.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        textMenuItem(
            text: strReportPost,
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 500), () {
                bottomSheetPostMenu(
                    contextMenu: context,
                    bottomSheetMenuType: BottomSheetMenuType.isReportPost);
              });
            }),
        heightBox(22.h),
        textMenuItem(text: strBlockUser, onTap: () => Navigator.pop(context)),
      ],
    ),
  );
}

bottomSheetPostMenu({
  required bottomSheetMenuType,
  required contextMenu,
}) {
  showModalBottomSheet(
    context: contextMenu,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            heightBox(14.h),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 6.h,
                width: 78.w,
                decoration: BoxDecoration(
                  color: colorDD9,
                  borderRadius: BorderRadius.all(Radius.circular(30.r)),
                ),
              ),
            ),
            bottomSheetMenuType == BottomSheetMenuType.isReportPost
                ? reportListWidget()
                : Container(),
            heightBox(14.h),
            bottomSheetMenuType == BottomSheetMenuType.isReportPost
                ? Expanded(
                    child: ListView.builder(
                        itemCount: reportList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9.0),
                            child: textMenuItem(
                                text: reportList[index],
                                onTap: () {
                                  Navigator.pop(context);
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    bottomSheetPostMenu(
                                        bottomSheetMenuType:
                                            BottomSheetMenuType.isDoneReport,
                                        contextMenu: contextMenu);
                                  });
                                }),
                          );
                        }),
                  )
                : bottomSheetMenuType == BottomSheetMenuType.isDoneReport
                    ? Center(child: reportDoneWidget())
                    : menuPostWidget(contextMenu)
          ],
        ),
      );
      //   ListView.builder(itemBuilder:
      //     (context, index) {
      //   return TextWidget(text: "Report Post",);
      // });
    },
  );
}

sharePostBottomSheet({required BuildContext context}) {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     isScrollControlled: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
//     ),
//     builder: (BuildContext context) {
//       SharePostViewModel sharePostViewModel =
//           Provider.of<SharePostViewModel>(context);

//       return Container(
//         padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 22.w),
//         decoration: BoxDecoration(
//           color: colorWhite,
//           borderRadius: BorderRadius.only(
//               topRight: Radius.circular(30.r), topLeft: Radius.circular(30.r)),
//         ),
//         height: MediaQuery.of(context).size.height * 0.96,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             heightBox(17.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: TextWidget(
//                       text: strSharePost,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                       color: colorBlack,
//                     ),
//                   ),
//                 ),
//                 svgImgButton(
//                     svgIcon: icCloseSheet,
//                     onTap: () {
//                       Navigator.pop(context);
//                     })
//               ],
//             ),
//             heightBox(22.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 shareWithTxt(
//                   text: strShareWithFrd,
//                   fontWeight: sharePostViewModel.isShareWithFrd
//                       ? FontWeight.w600
//                       : FontWeight.w400,
//                   onTap: () {
//                     sharePostViewModel.onTapShareWithFrdTxt();
//                   },
//                 ),
//                 widthBox(16.w),
//                 shareWithTxt(
//                   text: strShareOnSocialMedia,
//                   fontWeight: sharePostViewModel.isShareWithFrd
//                       ? FontWeight.w400
//                       : FontWeight.w600,
//                   onTap: () {
//                     sharePostViewModel.onTapShareWithSocialTxt();
//                   },
//                 ),
//               ],
//             ),
//             heightBox(28.h),
//             Expanded(
//               child: ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: sharePostViewModel.userList.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     var perUserData = sharePostViewModel.userList[index];
//                     return shareProfileCard(
//                         imgUserNet: perUserData.imgUrl,
//                         userName: perUserData.userName,
//                         subName: perUserData.subName,
//                         isVerify: perUserData.isVerify,
//                         isSelected: perUserData.isSelectShare,
//                         onSelectUser: () =>
//                             sharePostViewModel.onTapSendUser(index: index));
//                   }),
//             ),
//             CommonButton(
//               text: strDone,
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// Widget addMediaIcTxt({required String text, GestureTapCallback? onTap}) {
//   return PrimaryTextButton(
//     onPressed: () {},
//     title: '',
//   );
// }

// Widget addedMediaView() {
//   return GridTile(
//     child: ClipRRect(
//       borderRadius: BorderRadius.all(
//         Radius.circular(
//           10.r,
//         ),
//       ),
//       child: Image.network(
//         postImgTemp,
//         fit: BoxFit.cover,
//       ),
//     ),
//     header: Align(
//       alignment: Alignment.centerRight,
//       child: IconButton(
//           onPressed: () {},
//           icon: SvgPicture.asset(
//             icRemovePost,
//           )),
//     ),
//   );
}

Widget shareWithTxt(
    {required String text,
    required GestureTapCallback onTap,
    required FontWeight fontWeight}) {
  return GestureDetector(
    onTap: onTap,
    child: TextWidget(
      text: text,
      fontSize: 14.sp,
      fontWeight: fontWeight,
      color: colorBlack,
    ),
  );
}

Widget sendButton({GestureTapCallback? onTap, required bool isSelected}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 25.h,
      width: 49.w,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
      decoration: BoxDecoration(
        color: isSelected ? colorPrimaryA05 : colorPrimaryA05.withOpacity(0.16),
        borderRadius: BorderRadius.all(Radius.circular(90.r)),
      ),
      child: Center(
        child: TextWidget(
          text: strSend,
          color: isSelected ? colorWhite : colorPrimaryA05,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    ),
  );
}

Widget shareProfileCard(
    {String? imgUserNet,
    subName,
    userName,
    bool? isVerify,
    bool? isSelected,
    GestureTapCallback? onSelectUser}) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 5.h,
    ),
    padding: EdgeInsets.only(left: 17.w),
    height: 59.h,
    decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 1.0,
              offset: const Offset(0, 2)),
        ]),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        CachedNetworkImage(
          imageUrl: imgUserNet!,
          imageBuilder: (context, imageProvider) =>
              CircleAvatar(radius: 20.r, backgroundImage: imageProvider),
          placeholder: (context, url) => shimmerImg(
              child: CircleAvatar(
            radius: 20.r,
          )),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  TextWidget(
                    text: userName ?? "",
                    color: color221,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                  widthBox(6.w),
                  isVerify != null
                      ? isVerify
                          ? SvgPicture.asset(icVerifyBadge)
                          : Container()
                      : Container()
                ],
              ),
              TextWidget(
                text: subName ?? "",
                color: color55F,
                fontWeight: FontWeight.w400,
                fontSize: 11.sp,
              ),
            ],
          ),
        ),
        const Spacer(),
        sendButton(onTap: onSelectUser, isSelected: isSelected ?? false)
      ],
    ),
  );
}

Widget profileImgName({
  double? dpRadius,
  double? positionBottom,
  double? positionRight,
  userName,
  txtWithUName,
  subText,
  Color? userNameClr,
  txtWithUNameClr,
  subTxtClr,
  double? subTxtWidth,
  FontWeight? userNameFontWeight,
  txtWithUNameWeight,
  subTxtFontWeight,
  double? userNameFontSize,
  txtWithUNameSize,
  subTxtFontSize,
  bool? needDot,
  GestureTapCallback? onTapOtherProfile,
  required String? imgUserNet,
  required bool isVerifyWithName,
  required bool idIsVerified,
}) {
  return GestureDetector(
    onTap: onTapOtherProfile,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        imgProVerified(
            profileImg: imgUserNet,
            idIsVerified: idIsVerified,
            imgRadius: dpRadius ?? 20.r,
            positionBottom: positionBottom,
            positionRight: positionRight),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextWidget(
                    text: userName ?? "",
                    color: userNameClr ?? color221,
                    fontWeight: userNameFontWeight ?? FontWeight.w500,
                    fontSize: userNameFontSize ?? 14.sp,
                  ),
                  widthBox(6.w),
                  isVerifyWithName && idIsVerified
                      ? SvgPicture.asset(icVerifyBadge)
                      : Container(),
                  needDot != null
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          height: 3.h,
                          width: 3.w,
                          decoration: BoxDecoration(
                            color: color55C,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        )
                      : widthBox(6.w),
                  TextWidget(
                    text: txtWithUName ?? "",
                    color: txtWithUNameClr ?? color55F,
                    fontWeight: txtWithUNameWeight ?? FontWeight.w400,
                    fontSize: txtWithUNameSize ?? 12.sp,
                  ),
                ],
              ),
              SizedBox(
                width: subTxtWidth,
                child: TextWidget(
                  text: subText ?? "",
                  color: subTxtClr ?? color55F,
                  fontWeight: subTxtFontWeight,
                  fontSize: subTxtFontSize ?? 11.sp,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Widget musicPlayer(
//     {required String musicUrl, required Size screenSize, musicManager}) {
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       ValueListenableBuilder<ButtonState>(
//         valueListenable: musicManager.buttonNotifier,
//         builder: (_, value, __) {
//           switch (value) {
//             case ButtonState.loading:
//               return SizedBox(
//                 height: 32.h,
//                 width: 32.h,
//                 child: svgImgButton(
//                   svgIcon: icMusicPlayBtn,
//                 ),
//               );
//             case ButtonState.paused:
//               return SizedBox(
//                 height: 32.h,
//                 width: 32.h,
//                 child: svgImgButton(
//                     svgIcon: icMusicPlayBtn, onTap: musicManager.play),
//               );
//             case ButtonState.playing:
//               return SizedBox(
//                 height: 32.h,
//                 width: 32.h,
//                 child: svgImgButton(
//                     svgIcon: icMusicPauseBtn, onTap: musicManager.pause),
//               );
//           }
//         },
//       ),
//       widthBox(15.w),
//       ValueListenableBuilder<ProgressBarState>(
//         valueListenable: musicManager.progressNotifier,
//         builder: (_, value, __) {
//           return SizedBox(
//             width: screenSize.width * 0.6,
//           );
//         },
//       ),
//     ],
//   );
// }
