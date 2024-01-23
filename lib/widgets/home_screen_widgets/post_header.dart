import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../common_widgets.dart';
import '../profile_pic.dart';
import '../text_widget.dart';

class CustomPostHeader extends StatelessWidget {
  final VoidCallback? ontap;
  final VoidCallback? headerOnTap;
  final PostModel postModel;
  final bool? isVideoPost;
  final VoidCallback? onVertItemClick;
  final String postCreatorId;
  final bool isGhostPost;

  const CustomPostHeader(
      {super.key,
      this.ontap,
      this.isVideoPost = false,
      this.headerOnTap,
      this.onVertItemClick,
      required this.postCreatorId,
      required this.postModel,
      this.isGhostPost = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: StreamProvider.value(
        value: DataProvider().getSingleUser(postCreatorId),
        initialData: null,
        child: Consumer<UserModel?>(
          builder: (context, postCreator, b) {
            if (postCreator == null) {
              return Container();
            }
            return GestureDetector(
              onTap: isGhostPost
                  ? () => GlobalSnackBar.show(
                      message: "You can't visit a ghost profile")
                  : headerOnTap,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        isGhostPost
                            ? Container(
                                height: 35.h,
                                width: 35.h,
                                decoration: const BoxDecoration(
                                  color: colorF03,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(imgGhostUser),
                              )
                            : InkWell(
                                onTap: headerOnTap,
                                child: ProfilePic(
                                  pic: postCreator.imageStr,
                                  heightAndWidth: 35.h,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextWidget(
                                    onTap: isGhostPost
                                        ? () => GlobalSnackBar.show(
                                            message:
                                                "You can't visit a ghost profile")
                                        : headerOnTap,
                                    text: isGhostPost
                                        ? postCreator.ghostName
                                        : postCreator.username,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isVideoPost! ? colorFF7 : color221,
                                  ),
                                  widthBox(5.w),
                                  Visibility(
                                    visible:
                                        !isGhostPost && postCreator.isVerified,
                                    child: SvgPicture.asset(
                                      icVerifyBadge,
                                      width: 15.w,
                                      height: 15.h,
                                    ),
                                  )
                                ],
                              ),
                              Visibility(
                                visible: !isGhostPost &&
                                    postCreator.education.isNotEmpty,
                                child: SelectableText.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                          child: Icon(
                                        Icons.school,
                                        size: 15.sp,
                                        color: color55F.withOpacity(0.7),
                                      )),
                                      TextSpan(
                                        text: ' ${postCreator.education} ',
                                        style: TextStyle(
                                          color: color55F,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11.sp,
                                          fontFamily: strFontName,
                                        ),
                                      ),
                                      WidgetSpan(
                                          child: Visibility(
                                              visible: postCreator
                                                  .isEducationVerified,
                                              child: SvgPicture.asset(
                                                icVerifyBadge,
                                                height: 13,
                                              ))),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Visibility(
                                visible:
                                    !isGhostPost && postCreator.work.isNotEmpty,
                                child: SelectableText.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                          child: Icon(
                                        Icons.work,
                                        size: 14.sp,
                                        color: color55F.withOpacity(0.7),
                                      )),
                                      TextSpan(
                                        text: ' ${postCreator.work} ',
                                        style: TextStyle(
                                          color: color55F,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11.sp,
                                          fontFamily: strFontName,
                                        ),
                                      ),
                                      WidgetSpan(
                                          child: Visibility(
                                              visible:
                                                  postCreator.isWorkVerified,
                                              child: SvgPicture.asset(
                                                icVerifyBadge,
                                                height: 13,
                                              ))),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Visibility(
                                visible: postModel.showPostTime ||
                                    postModel.locationName.isNotEmpty,
                                child: TextWidget(
                                  text:
                                      "${postModel.showPostTime ? "${convertDateIntoTime(postModel.createdAt)} " : ""}${postModel.locationName.isEmpty ? "" : "at ${postModel.locationName}"}",
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isVideoPost!
                                      ? colorFF7.withOpacity(0.6)
                                      : const Color(0xff5f5f5f),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: onVertItemClick,
                      child: Icon(
                        Icons.more_vert,
                        color:
                            isVideoPost! ? colorFF7 : const Color(0xffafafaf),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
