import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/color_resources.dart';
import '../resources/image_resources.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? prefixIconName;
  final bool? shouldShowBackButton;
  final PreferredSizeWidget? bottom;
  final bool? isPrefixIcon;
  final Widget? leading;
  final Widget? prefixWidget;
  final bool automaticallyImplyLeading;
  final GestureTapCallback? onTapPrefix;
  final GestureTapCallback? onPressBack;
  final Color? statusBarColor;
  final Color? backgroundColor;
  final Brightness? statusBarIconBrightness;
  final Brightness? systemNavigationBarIconBrightness;
  final Brightness? statusBarBrightness;
  final GestureTapCallback? onTapAction;
  final double? heightToolBar;
  final List<Widget>? actionsWidget;

  const CommonAppBar(
      {super.key,
      required this.title,
      this.shouldShowBackButton = true,
      this.bottom,
      this.isPrefixIcon,
      this.prefixIconName,
      this.onTapPrefix,
      this.onPressBack,
      this.automaticallyImplyLeading = true,
      this.leading,
      this.statusBarColor,
      this.prefixWidget,
      this.onTapAction,
      this.backgroundColor,
      this.statusBarIconBrightness,
      this.systemNavigationBarIconBrightness,
      this.statusBarBrightness,
      this.heightToolBar,
      this.actionsWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: statusBarColor ?? Colors.transparent,
          // status bar color
          statusBarIconBrightness: statusBarIconBrightness ?? Brightness.light,
          // systemNavigationBarColor: colorFA,
          systemNavigationBarIconBrightness:
              systemNavigationBarIconBrightness ?? Brightness.dark,
          statusBarBrightness: statusBarBrightness ?? Brightness.dark),
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: heightToolBar ?? 70,
      title: TextWidget(
        text: title,
        color: colorWhite,
        fontWeight: FontWeight.w400,
        fontSize: 18.sp,
      ),
      centerTitle: true,
      leading: (shouldShowBackButton ?? true)
          ? leading
          // ??
          //     GestureDetector(
          //       behavior: HitTestBehavior.opaque,
          //       onTap: onPressBack ??
          //           () {
          //             if (Navigator.canPop(context)) {
          //               Navigator.pop(context);
          //             }
          //           },
          //       child: Container(
          //         height: 5,
          //         width: 5,
          //         margin: const EdgeInsets.only(left: 22),
          //         // padding: const EdgeInsets.only(bottom: 12, right: 5, left: 5, top: 10),
          //         // child: SvgPicture.asset(icArrowLeft, color: colorWhite),
          //       ),
          //     )
          : null,
      leadingWidth: 55,
      actions: actionsWidget ??
          [
            prefixIconName != null
                ? Container(
                    margin: const EdgeInsets.only(right: 22),
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 25),
                    child: TextWidget(
                      text: prefixIconName,
                      color: colorWhite,
                      fontSize: 14.sp,
                      onTap: onTapAction,
                    ),
                  )
                : prefixWidget ?? const SizedBox.shrink(),
          ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(heightToolBar ?? 90);
}

statusBarDarkMode() {
  return SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));
}

statusBarLightMode() {
  return SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light));
}

whiteBgAppBar(
    {String? title,
    double? fontSize,
    FontWeight? fontWeight,
    Color? backgroundClr,
    double? elevation,
    double? iconSize,
    String? leadIconSvg,
    GestureTapCallback? onTapLeadIc,
    double? leadHorPadding,
    double? leadVerPadding,
    double? leadingWidth,
    double? titleSpacing,
    Widget? customTitle,
    bool? centerTitle,
    bool? autoImplyLead,
    List<Widget>? actionsWidgets}) {
  return AppBar(
    backgroundColor: backgroundClr ?? Colors.white,
    leadingWidth: leadingWidth,
    systemOverlayStyle: statusBarDarkMode(),
    centerTitle: true,
    title: customTitle ??
        Text(
          title ?? "",
          style: TextStyle(
              color: color13F,
              fontFamily: strFontName,
              fontWeight: fontWeight ?? FontWeight.w600,
              fontSize: fontSize ?? 16.sp),
        ),
    elevation: elevation ?? 5,
    actions: actionsWidgets,
    titleSpacing: titleSpacing,
    automaticallyImplyLeading: autoImplyLead ?? true,
    leading: leadIconSvg != null
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: leadHorPadding ?? 0, vertical: leadVerPadding ?? 0),
            child: GestureDetector(
              onTap: onTapLeadIc,
              child: SvgPicture.asset(
                leadIconSvg,
                height: iconSize ?? 32.h,
                width: iconSize ?? 32.w,
              ),
            ),
          )
        : null,
  );
}

iosBackIcAppBar({
  String? title,
  GestureTapCallback? onTapLead,
  List<Widget>? actionsWidgets,
  Widget? customTitle,
  bool? centerTitle,
  double? leadingWidth,
  double? titleSpacing,
  bool? autoImplyLead,
}) {
  return whiteBgAppBar(
      title: title,
      elevation: 1,
      leadIconSvg: icIosBackArrow,
      iconSize: 15,
      leadVerPadding: 13.h,
      onTapLeadIc: onTapLead,
      actionsWidgets: actionsWidgets,
      customTitle: customTitle,
      centerTitle: centerTitle,
      leadingWidth: leadingWidth);
}

sliverBgAppBar(
    {String? title,
    double? fontSize,
    FontWeight? fontWeight,
    Color? backgroundClr,
    double? elevation,
    String? leadIconSvg,
    GestureTapCallback? onTapLeadIc,
    GestureTapCallback? onTapNotifyIc,
    GestureTapCallback? onTapAddPostIc,
    double? leadHorPadding,
    String? notificationCount}) {
  return SliverAppBar(
    backgroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    // systemOverlayStyle: statusBarDarkMode(),
    centerTitle: true,
    title: title != null
        ? Text(
            title,
            style: TextStyle(
                color: color13F,
                fontFamily: strFontName,
                fontWeight: fontWeight ?? FontWeight.w600,
                fontSize: fontSize ?? 16.sp),
          )
        : null,
    elevation: 3,
    forceElevated: true,
    leadingWidth: 65.w,
    leading: Center(
      child: GestureDetector(
        onTap: onTapLeadIc,
        child: SvgPicture.asset(
          leadIconSvg!,
          height: 32.h,
          width: 32.w,
        ),
      ),
    ),
    actions: [
      GestureDetector(
          onTap: onTapAddPostIc,
          child: Image.asset(
            imgAddPost,
            height: 28.h,
            width: 28.w,
          )),
      Center(
        child: Padding(
          padding: EdgeInsets.only(left: 2.w, right: 11.w),
          child: GestureDetector(
            onTap: onTapNotifyIc,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SvgPicture.asset(
                      icNotifyBell,
                      width: 21.w,
                      height: 24.h,
                    ),
                  ),
                ),
                notificationCount != null
                    ? Positioned(
                        top: 10.0,
                        right: 2.0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: colorPrimaryA05,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 17.w,
                            minHeight: 17.h,
                          ),
                          child: Center(
                            child: TextWidget(
                              text: notificationCount,
                              color: colorWhite,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

PreferredSizeWidget onlyLeadIcAppbar(
    {bool? isLightMode,
    GestureTapCallback? onTap,
    String? leadIcon,
    List<Widget>? actionsWidget}) {
  return CommonAppBar(
    statusBarColor: Colors.transparent,
    statusBarBrightness:
        isLightMode == null ? Brightness.light : Brightness.dark,
    statusBarIconBrightness:
        isLightMode == null ? Brightness.dark : Brightness.light,
    // systemOverlayStyle: isLightMode == null ? statusBarDarkMode() : statusBarLightMode(),
    //     : Colors.transparent,
    // systemOverlayStyle: isLightMode == null ? SystemUiOverlayStyle.dark: null,
    title: "",
    leading: Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
          onTap: onTap, child: SvgPicture.asset(leadIcon ?? icLeftArrow)),
    ),
    actionsWidget: actionsWidget,
  );
}
