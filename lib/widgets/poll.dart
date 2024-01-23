import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Poll extends StatelessWidget {
  const Poll({super.key, required this.postModel});

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<PostProvider>(context);

    PollVotedUsers? pollVotedUsers;

    var votedUserMap = postModel.mediaData.first.pollVotedUsers!
        .map((e) => PollVotedUsers.fromMap(e))
        .toList();

    if (votedUserMap.isNotEmpty) {
      for (var v in votedUserMap) {
        if (v.id == currentUserUID) {
          pollVotedUsers = v;
        }
      }
    }

    prov.countVideoViews(groupId: null, postModel: postModel);

    return FlutterPolls(
      pollId: postModel.id,
      onVoted: (v, i) async {
        prov.updatePollData(postId: postModel.id, option: v.id!);
        return true;
      },
      hasVoted: pollVotedUsers == null ? false : true,
      userVotedOptionId:
          pollVotedUsers == null ? "" : pollVotedUsers.votedOption,
      pollTitle: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          text: postModel.mediaData.first.pollQuestion.toString(),
          fontWeight: FontWeight.w600,
        ),
      ),
      pollOptions: postModel.mediaData.first.pollOptions!
          .map(
            (e) => PollOption(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextWidget(
                    text: e['option'],
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              id: e['option'],
              votes: e['votes'],
            ),
          )
          .toList(),
    );
  }
}
