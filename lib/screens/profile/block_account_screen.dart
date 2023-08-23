import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../widgets/common_widgets.dart';

class BlockAccountsScreen extends StatelessWidget {
  const BlockAccountsScreen({Key? key}) : super(key: key);

  // bottomSheetBlockAccount(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
  //       ),
  //       builder: (BuildContext context) {
  //         return Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 24.w),
  //             child: Column(mainAxisSize: MainAxisSize.min, children: [
  //               heightBox(14.h),
  //               Container(
  //                 height: 6.h,
  //                 width: 78.w,
  //                 decoration: BoxDecoration(
  //                   color: colorDD9,
  //                   borderRadius: BorderRadius.all(Radius.circular(30.r)),
  //                 ),
  //               ),
  //               heightBox(28.h),
  //               CachedNetworkImage(
  //                 imageUrl: postProfileImg,
  //                 imageBuilder: (context, imageProvider) => CircleAvatar(
  //                     radius: 33.r, backgroundImage: imageProvider),
  //                 placeholder: (context, url) => shimmerImg(
  //                     child: CircleAvatar(
  //                   radius: 33.r,
  //                 )),
  //                 errorWidget: (context, url, error) => const Icon(Icons.error),
  //               ),
  //               heightBox(8.h),
  //               TextWidget(
  //                 text: "Anette Black",
  //                 color: colorBlack,
  //                 fontSize: 16.sp,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //               heightBox(28.h),
  //               horizonLine(width: double.maxFinite, color: colorDD3),
  //               heightBox(26.h),
  //               TextWidget(
  //                 text: strUnblock,
  //                 color: color13F,
  //                 fontSize: 16.sp,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               heightBox(2.h),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 60.w),
  //                 child: TextWidget(
  //                   text: strReallyUnblockPerson,
  //                   color: color55F,
  //                   textAlign: TextAlign.center,
  //                   fontSize: 14.sp,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 28.h),
  //                 child: CommonButton(
  //                   text: strUnblockNow,
  //                   width: 150.w,
  //                 ),
  //               )
  //             ]));
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    return Scaffold(
      appBar: primaryAppbar(title: 'Block Accounts', elevation: 0.2),
      body: Consumer<List<UserModel>?>(builder: (context, users, b) {
        if (users == null || currentUser == null) {
          return centerLoader();
        }
        final filterList = users
            .where((element) => currentUser.blockIds.contains(element.id))
            .toList();
        if (filterList.isEmpty) {
          return const Center(
            child: Text("You didn't block any account yet"),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: filterList.length,
            itemBuilder: (context, index) {
              return FollowFollowingTile(
                  user: filterList[index],
                  ontapToggleFollow: () => postProvider.blockUnblockUser(
                      currentUser: currentUser, appUser: filterList[index].id),
                  btnName: 'Remove');
            });
      }),
    );
  }
}
