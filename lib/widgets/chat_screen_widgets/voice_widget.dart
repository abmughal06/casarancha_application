import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceRecordingWidget extends StatelessWidget {
  const VoiceRecordingWidget(
      {super.key,
      required this.isRecording,
      required this.isRecordingSend,
      required this.duration,
      required this.onTapDelete,
      required this.isRecorderLock,
      required this.sendRecording});

  final bool isRecording;
  final bool isRecordingSend;
  final String duration;
  final VoidCallback onTapDelete;
  final bool isRecorderLock;
  final VoidCallback sendRecording;

  @override
  Widget build(BuildContext context) {
    if (isRecording) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            isRecorderLock
                ? IconButton(
                    onPressed: onTapDelete,
                    icon: const Icon(Icons.delete, color: colorPrimaryA05))
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: isRecorderLock ? 50 : 0),
              child: TextWidget(
                text: duration,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: colorPrimaryA05,
              ),
            ),
            isRecorderLock
                ? Container()
                : TextWidget(
                    text: appText(context).slideCancel,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: color221,
                  ),
            isRecorderLock
                ? Container()
                : const Icon(Icons.swipe_left_alt_rounded),
          ],
        ),
      );
    }

    return Container();
  }
}
