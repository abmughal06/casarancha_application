import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/base_stateful_widget.dart';
import '../../resources/color_resources.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_appbar.dart';
import '../../widgets/common_widgets.dart';

class BlockAccountsScreen extends StatefulWidget {
  const BlockAccountsScreen({Key? key}) : super(key: key);

  @override
  State<BlockAccountsScreen> createState() => _BlockAccountsScreenState();
}

class _BlockAccountsScreenState
    extends BaseStatefulWidgetState<BlockAccountsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return iosBackIcAppBar(
      title: strBlockAccounts,
      onTapLead: () => goBack(),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  _bottomSheetBlockAccount() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
        ),
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                heightBox(14.h),
                Container(
                  height: 6.h,
                  width: 78.w,
                  decoration: BoxDecoration(
                    color: colorDD9,
                    borderRadius: BorderRadius.all(Radius.circular(30.r)),
                  ),
                ),
                heightBox(28.h),
                CachedNetworkImage(
                  imageUrl: postProfileImg,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 33.r, backgroundImage: imageProvider),
                  placeholder: (context, url) => shimmerImg(
                      child: CircleAvatar(
                    radius: 33.r,
                  )),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                heightBox(8.h),
                TextWidget(
                  text: "Anette Black",
                  color: colorBlack,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                heightBox(28.h),
                horizonLine(width: double.maxFinite, color: colorDD3),
                heightBox(26.h),
                TextWidget(
                  text: strUnblock,
                  color: color13F,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                heightBox(2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: TextWidget(
                    text: strReallyUnblockPerson,
                    color: color55F,
                    textAlign: TextAlign.center,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 28.h),
                  child: CommonButton(
                    text: strUnblockNow,
                    width: 150.w,
                  ),
                )
              ]));
        });
  }

  @override
  Widget buildBody(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.minHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return cardProfileStrAction(
                      strProfileImg: postProfileImg,
                      userName: "XRed13Fox",
                      idIsVerified: true,
                      subTxt: "Xender Rendos",
                      strAction: strUnblock,
                      onTapAction: () {
                        _bottomSheetBlockAccount();
                      });
                }),
          ));
    });
  }
}
