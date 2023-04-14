import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/base_stateful_widget.dart';
import '../../resources/image_resources.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_appbar.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({Key? key}) : super(key: key);

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends BaseStatefulWidgetState<AudioCallScreen> {
  @override
  // TODO: implement shouldHaveSafeArea
  bool get shouldHaveSafeArea => false;

  @override
  // TODO: implement isBackgroundImage
  bool get isBackgroundImage => true;

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // TODO: implement buildAppBar
    return CommonAppBar(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      title: "",
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child:
            GestureDetector(onTap: () {goBack();}, child: SvgPicture.asset(icLeftArrowCall)),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.minHeight),
          child: Stack(
            children: [
              Container(
                  color: colorA51,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 77.r,
                        backgroundColor: colorWhite,
                        child: CircleAvatar(
                            radius: 75.r,
                            backgroundColor: colorWhite,
                            backgroundImage:
                                Image.network(videoCallBack).image),
                      ),
                      heightBox(24.h),
                      TextWidget(
                        text: "JaneC_985",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: colorWhite,
                      ),
                      TextWidget(
                        text: "Jane Cooper",
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                        color: colorWhite.withOpacity(.7),
                      ),

                    ],
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 35.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        imgCallMute,
                        height: 50.h,
                        width: 50.w,
                      ),
                      widthBox(44.w),
                      Image.asset(
                        imgCallPickRed,
                        height: 65.h,
                        width: 65.w,
                      ),
                      widthBox(44.w),
                      Image.asset(
                        imgCallSound,
                        height: 50.h,
                        width: 50.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
    });
  }
}
