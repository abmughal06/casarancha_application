import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/media_details.dart';
import '../resources/color_resources.dart';
import 'common_widgets.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SelectableTextWidget(
            text: "${widget.postModel.mediaData.first.pollQuestion}",
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: color221,
          ),
        ),
        heightBox(15.h),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.postModel.mediaData.first.pollOptions!.length,
          separatorBuilder: (context, index) => heightBox(12.h),
          itemBuilder: (context, index) {
            late List<PollOptions> pollOptions;
            late int largestValue;
            int totalVotes = 0;
            List<int> votes = [];
            pollOptions = widget.postModel.mediaData.first.pollOptions!
                .map((e) =>
                    PollOptions(option: e['option'], votes: e['votes'] ?? []))
                .toList();

            for (var i in pollOptions) {
              votes.add(i.votes.length);
              totalVotes += i.votes.length;
            }
            largestValue = findLargestValue(votes);
            bool isLargestVote = pollOptions[index].votes.isEmpty
                ? false
                : pollOptions[index].votes.length == largestValue;
            int votePercentage =
                (pollOptions[index].votes.length * 100) ~/ totalVotes;
            return GestureDetector(
              onTap: () => prov.updatePollData(
                  postId: widget.postModel.id, index: index),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.h),
                  border: Border.all(
                      color: isLargestVote ? Colors.blue : color221,
                      width: 1.w),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: LinearProgressIndicator(
                        //Here you pass the percentage
                        value: votePercentage / 100,
                        color: isLargestVote
                            ? Colors.blue.withAlpha(100)
                            : Colors.grey.withAlpha(100),
                        backgroundColor: isLargestVote
                            ? Colors.blue.withAlpha(50)
                            : Colors.grey.withAlpha(50),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: pollOptions[index].option,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: color221,
                          ),
                          TextWidget(
                            text: "%$votePercentage",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: color221,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

int findLargestValue(List<int> numbers) {
  if (numbers.isEmpty) {
    throw ArgumentError("The list cannot be empty");
  }

  int largestValue = numbers[0];

  for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] > largestValue) {
      largestValue = numbers[i];
    }
  }

  return largestValue;
}
