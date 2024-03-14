import 'package:casarancha/models/message.dart';
import 'package:casarancha/resources/strings.dart';
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
  });
  final bool isMe;
  final String appUserId;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? MediaQuery.of(context).size.width * .2 : 0,
              right: isMe ? 0 : MediaQuery.of(context).size.width * .2,
            ),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: message.isReply
                  ? Container(
                      width: MediaQuery.of(context).size.width * .8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isMe ? 10.r : 16.r),
                            topRight: Radius.circular(isMe ? 16.r : 10.r),
                            bottomLeft: Radius.circular(isMe ? 10.r : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 10.r)),
                        color: (isMe ? colorF03.withOpacity(0.6) : colorFF4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .8,
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 10, bottom: 12),
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: color080.withOpacity(0.2),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(isMe ? 5.r : 12.r),
                                  topRight: Radius.circular(isMe ? 12.r : 5.r),
                                  bottomLeft: Radius.circular(isMe ? 5.r : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 5.r)),
                            ),
                            child: SelectableText.rich(
                              TextSpan(
                                style: TextStyle(
                                    color: color221,
                                    fontFamily: strFontName,
                                    fontSize: calculateFontSize(
                                        message.caption.toString())),
                                children:
                                    linkifyMessage(message.caption.toString()),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: SelectableText.rich(
                              TextSpan(
                                style: TextStyle(
                                    color: color221,
                                    fontFamily: strFontName,
                                    fontSize: calculateFontSize(
                                        message.content.toString())),
                                children:
                                    linkifyMessage(message.content.toString()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isMe ? 10.r : 16.r),
                            topRight: Radius.circular(isMe ? 16.r : 10.r),
                            bottomLeft: Radius.circular(isMe ? 10.r : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 10.r)),
                        color: (isMe ? colorF03.withOpacity(0.6) : colorFF4),
                      ),
                      padding: EdgeInsets.all(8.h),
                      child: SelectableText.rich(
                        TextSpan(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: strFontName,
                              fontSize: calculateFontSize(
                                  message.content.toString())),
                          children: linkifyMessage(message.content.toString()),
                        ),
                      ),
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
                        child: message.isSeen
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
                  text: convertDateIntoTime(message.createdAt),
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
        style: const TextStyle(color: Colors.blue, fontFamily: strFontName),
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
    spans.add(TextSpan(
        text: message.substring(lastMatchEnd),
        style: const TextStyle(fontFamily: strFontName)));
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
