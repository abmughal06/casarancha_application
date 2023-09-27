import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../widgets/common_widgets.dart';

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({Key? key, required this.group}) : super(key: key);
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    final users = context.watch<List<UserModel>?>();
    return Scaffold(
      appBar: primaryAppbar(title: '${group.name} Members', elevation: 0.2),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: colorPrimaryA05,
              unselectedLabelColor: colorAA3,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              indicatorColor: colorF03,
              indicatorPadding:
                  EdgeInsets.symmetric(vertical: 5.h, horizontal: 60.w),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  text: 'Members',
                ),
                Tab(
                  text: 'Join Requests',
                ),
              ],
            ),
            heightBox(15.h),
          ],
        ),
      ),
    );
  }
}
