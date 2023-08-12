import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../text_widget.dart';

class VoiceView extends StatefulWidget {
  const VoiceView({Key? key}) : super(key: key);

  @override
  State<VoiceView> createState() => _VoiceViewState();
}

class _VoiceViewState extends State<VoiceView> {
  @override
  Widget build(BuildContext context) {
    final voice = Provider.of<ChatProvider>(context);
    return Row(
      children: [
        GestureDetector(
          onLongPress: () {
            voice.record();
          },
          onLongPressEnd: (d) {
            voice.stop(context);
          },
          child: Icon(
            Icons.mic_none,
            size: 25.sp,
            color: color221,
          ),
        ),
        StreamBuilder<RecordingDisposition>(
          stream: voice.recorder.onProgress,
          builder: (context, snap) {
            final duration = snap.hasData ? snap.data!.duration : Duration.zero;
            if (duration == Duration.zero) {
              return Container();
            }
            return TextWidget(
              text: "${duration.inSeconds.toDouble().toInt()} s",
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: colorPrimaryA05,
            );
          },
        ),
      ],
    );
  }
}

class VoiceRecorder extends ChangeNotifier {}
