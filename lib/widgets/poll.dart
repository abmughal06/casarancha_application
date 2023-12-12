import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:provider/provider.dart';

import '../models/media_details.dart';

class Poll extends StatefulWidget {
  const Poll({super.key, required this.postModel});

  final PostModel postModel;

  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<PostProvider>(context);
    return FlutterPolls(
      pollId: widget.postModel.id,
      onVoted: (PollOption pollOption, int newTotalVotes) async {
        prov.updatePollData(
            postId: widget.postModel.id,
            index: int.parse(pollOption.id.toString()));
        return true;
      },
      userToVote: 'dada',
      votesText: '',
      pollTitle: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          text: widget.postModel.mediaData.first.pollQuestion.toString(),
          fontWeight: FontWeight.w600,
        ),
      ),
      // hasVoted: false,
      // userVotedOptionId: currentUserUID,
      pollOptions: List.generate(
          widget.postModel.mediaData.first.pollOptions!.length, (index) {
        var poll = widget.postModel.mediaData.first.pollOptions!;
        var p = PollOptions.fromMap(poll[index]);
        return PollOption(
          id: index.toString(),
          title: Text(p.option),
          votes: p.votes.length,
        );
      }),
    );
  }
}

// int findLargestValue(List<int> numbers) {
//   if (numbers.isEmpty) {
//     throw ArgumentError("The list cannot be empty");
//   }

//   int largestValue = numbers[0];

//   for (int i = 1; i < numbers.length; i++) {
//     if (numbers[i] > largestValue) {
//       largestValue = numbers[i];
//     }
//   }

//   return largestValue;
// }
