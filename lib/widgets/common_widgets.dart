import 'dart:io';

import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../resources/color_resources.dart';
import '../resources/localization_text_strings.dart';
import '../resources/strings.dart';
import 'home_page_widgets.dart';

Widget heightBox(double height) {
  return SizedBox(height: height);
}

Widget widthBox(double width) {
  return SizedBox(width: width);
}

Widget horizonLine(
    {required double width, double? horizontalMargin, Color? color}) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 0),
      color: color ?? colorDDC,
      height: 1.h,
      width: width);
}

Widget verticalLine(
    {required double height,
    double? verticalMargin,
    horizontalMargin,
    Color? color}) {
  return Container(
      margin: EdgeInsets.symmetric(
          vertical: verticalMargin ?? 0, horizontal: horizontalMargin ?? 0),
      color: color ?? colorDD3,
      height: height.h,
      width: 1.w);
}

Widget svgImgButton(
    {required String svgIcon,
    GestureTapCallback? onTap,
    double? width,
    double? height}) {
  return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        svgIcon,
        width: width,
        height: height,
      ));
}

Widget dateDropDown(
    {double? height, double? width, String? text, GestureTapCallback? onTap}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: colorFF3,
          borderRadius: BorderRadius.circular(16.0),
          // border: Border.all(color: colorF73 ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text: text ?? "",
              fontSize: 14.sp,
              color: color080,
              fontWeight: FontWeight.w400,
            ),
            widthBox(15.w),
            SvgPicture.asset(icDropDown)
          ],
        ),
      ),
    ),
  );
}

Widget imgProVerified(
    {double? imgRadius,
    double? positionBottom,
    double? positionRight,
    required String? profileImg,
    required bool idIsVerified}) {
  return Container(
      height: 40.w,
      width: 40.w,
      margin: EdgeInsets.only(bottom: 12.w),
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(3.w),
              child: ClipOval(
                child: FadeInImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(profileImg!),
                  placeholder: const AssetImage(imgUserPlaceHolder),
                ),
              ),
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: Visibility(
                    visible: idIsVerified,
                    child: SvgPicture.asset(icVerifyBadge)))
          ],
        ),
      ));
}

Widget customTabTxt(
    {required String text,
    required bool isSelectedTab,
    required GestureTapCallback onTap}) {
  return isSelectedTab
      ? Column(
          children: [
            TextWidget(
              text: text,
              color: colorPrimaryA05,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            heightBox(8.h),
            Container(
              height: 2.h,
              width: 22.w,
              color: colorF03,
            )
          ],
        )
      : GestureDetector(
          onTap: onTap,
          child: TextWidget(
            text: text,
            color: colorAA3,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        );
}

Widget commonTabBar(
    {TabController? controller, required List<Widget> tabsList}) {
  return TabBar(
    controller: controller,
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorWeight: 2.0,
    isScrollable: false,
    labelColor: colorPrimaryA05,
    indicatorColor: colorF03,
    unselectedLabelColor: colorAA3,
    labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
    labelStyle: TextStyle(
      fontSize: 14.sp,
      fontFamily: strFontName,
      fontWeight: FontWeight.w400,
    ),
    tabs: tabsList,
  );
}

Widget cardProfileStrAction(
    {required String strProfileImg,
    required String userName,
    required String subTxt,
    required String strAction,
    required bool idIsVerified,
    double? paddingHorizon,
    GestureTapCallback? onTapAction,
    GestureTapCallback? onTapOtherProfile}) {
  return Container();
}

Widget acceptDeclineBtn(
    {required bool isAcceptBtn, GestureTapCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 24.h,
      width: 67.w,
      decoration: BoxDecoration(
        color: isAcceptBtn ? colorF03 : colorAA3,
        borderRadius: BorderRadius.all(
          Radius.circular(7.r),
        ),
      ),
      child: Center(
        child: TextWidget(
          text: isAcceptBtn ? strAccept : strDecline,
          color: isAcceptBtn ? color13F : colorWhite,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
    ),
  );
}

Widget profileAcceptDecline(
    {String? imgUserNet,
    String? userName,
    String? subText,
    String? timeAgo = strMinAgo,
    GestureTapCallback? onTapAccept,
    GestureTapCallback? onTapOtherProfile,
    GestureTapCallback? onTapDecline}) {
  return Padding(
    padding: EdgeInsets.all(12.h),
    child: Container(
      height: 100.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: colorPrimaryA05.withOpacity(.20),
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.grey.shade300,
// offset: const Offset(-5,0),
            ),
            BoxShadow(
              color: Colors.grey.shade300,
// offset: const Offset(5,0),
            )
          ]),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileImgName(
                  onTapOtherProfile: onTapOtherProfile,
                  imgUserNet: imgUserNet,
                  isVerifyWithName: true,
                  idIsVerified: true,
                  userName: userName,
                  userNameFontWeight: FontWeight.w600,
                  subText: subText,
                  subTxtFontSize: 12.sp,
                  subTxtClr: colorAA3),
              const Spacer(),
              TextWidget(
                text: timeAgo,
                color: color55F,
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
              ),
            ],
          ),
          heightBox(8.h),
          Row(
            children: [
              widthBox(50.w),
              acceptDeclineBtn(isAcceptBtn: true, onTap: onTapAccept),
              widthBox(10.w),
              acceptDeclineBtn(isAcceptBtn: false, onTap: onTapDecline),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget shimmerImg(
    {double? height,
    double? width,
    double? borderRadius,
    BoxBorder? border,
    BoxShape? boxShape,
    Widget? child}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: child ??
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey,
            // shape: boxShape ?? BoxShape.rectangle,
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            border: border,
          ),
        ),
  );
}

Widget searchTextField(
    {required BuildContext context,
    TextEditingController? controller,
    Widget? suffixIcon,
    ValueChanged<String>? onChange,
    void Function(String)? onFieldSubmitted,
    String? hintText}) {
  return TextEditingWidget(
    controller: controller,
    onChanged: onChange,
    hint: hintText ?? strSearchHint,
    color: colorFF4,
    suffixIconWidget: suffixIcon,
    fontWeightHint: FontWeight.w400,
    hintColor: color55F,
    prefixIcon: Padding(
      padding: const EdgeInsets.all(15.0),
      child: SvgPicture.asset(icSearchText),
    ),
    onFieldSubmitted: onFieldSubmitted,
    textInputType: TextInputType.text,
    textInputAction: TextInputAction.search,
    onEditingComplete: () => FocusScope.of(context).unfocus(),
  );
}

Widget centerLoader({double? size, Color? color}) {
  return Center(
    child: SizedBox(
        height: size ?? 30.w,
        width: size ?? 30.w,
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: color ?? colorPrimaryA05,
                strokeWidth: 1,
              )
            : CupertinoActivityIndicator(
                color: color,
              )),
  );
}
