import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupNotificationBadge extends StatelessWidget {
  const GroupNotificationBadge({
    super.key,
    required this.groupId,
    required this.child,
  });

  final String groupId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: DataProvider().singleGroup(groupId),
      initialData: null,
      catchError: (context, error) => null,
      child: Consumer<GroupModel?>(
        builder: (context, group, c) {
          if (group == null) {
            return widthBox(0);
          } else {
            return Badge(
              isLabelVisible: group.joinRequestIds.isNotEmpty &&
                  (group.creatorId == currentUserUID ||
                      group.adminIds.contains(currentUserUID)),
              label: Text(group.joinRequestIds.length.toString()),
              child: child,
            );
          }
        },
      ),
    );
  }
}
