import 'package:casarancha/utils/snackbar.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../text_widget.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.message,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
  });

  final String message;
  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: isMe ? 70 : 0, right: isMe ? 0 : 70),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(
                        isMe ? 16.r : 0,
                      ),
                      bottomRight: Radius.circular(
                        isMe ? 0 : 16.r,
                      )),
                  color: (isMe ? colorF03.withOpacity(0.6) : colorFF4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                child: SelectableText.rich(
                  TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: calculateFontSize(message)),
                    children: linkifyMessage(message),
                  ),
                ),
                // SelectableTextWidget(
                //   text: message,
                //   fontSize: calculateFontSize(message),
                //   fontWeight: FontWeight.w500,
                //   color: Colors.black,
                // ),
              ),
            ),
          ),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isMe
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: isSeen
                            ? SvgPicture.asset(
                                icChatMsgSend,
                              )
                            : SvgPicture.asset(
                                icChatMsgSend,
                                color: Colors.black.withOpacity(0.5),
                              ),
                      )
                    : Container(),
                TextWidget(
                  text: convertDateIntoTime(date),
                  color: colorAA3,
                  fontSize: 11.sp,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}

List<TextSpan> linkifyMessage(String message) {
  List<TextSpan> spans = [];

  final pattern = RegExp(r'(https?://)?(?:www\.)?\S+\.\S+(?:[^\s.,](?=\s|$))?');

  Iterable<RegExpMatch> matches = pattern.allMatches(message);

  int lastMatchEnd = 0;

  for (RegExpMatch match in matches) {
    if (match.start > lastMatchEnd) {
      spans.add(TextSpan(text: message.substring(lastMatchEnd, match.start)));
    }
    spans.add(
      TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _onOpen(LinkableElement(
                match.group(0)!,
                match.group(0)!,
              )),
      ),
    );
    lastMatchEnd = match.end;
  }

  if (lastMatchEnd < message.length) {
    spans.add(TextSpan(text: message.substring(lastMatchEnd)));
  }

  return spans;
}

void _onOpen(LinkableElement link) async {
  String url = link.url;
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'http://$url';
  }
  Uri? uri = Uri.tryParse(url);

  if (uri != null) {
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      GlobalSnackBar.show(message: "Can't launch url => $url");
    }
  } else {
    GlobalSnackBar.show(message: "$url is not valid");
  }
}

double calculateFontSize(String message) {
  if (emojiRegex().allMatches(message).isNotEmpty &&
      RegExp(r'[A-Za-z\s]').allMatches(message).isEmpty) {
    return 27.sp;
  } else {
    return 14.sp;
  }
}
