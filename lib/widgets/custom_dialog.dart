import 'dart:io';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/widgets/shared/alert_dialog.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../screens/dashboard/provider/download_provider.dart';

class CustomDownloadDialog extends StatelessWidget {
  const CustomDownloadDialog(
      {super.key,
      required this.path,
      required this.url,
      required this.isVideo,
      required this.isImage});

  final String path;
  final bool isVideo;
  final bool isImage;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(builder: (context, download, b) {
      return CustomAdaptiveAlertDialog(
        title: appText(context).strDownloadFile,
        actiionBtnName: appText(context).strYes,
        actionBtnColor: color221,
        onAction: () {
          if (isVideo) {
            download.videoDownloading(url, path, context);
          } else if (isImage) {
            download.imageDownloading(url, path);
          } else {
            download.startDownloading(url, path, context);
          }
        },
        alertMsg: download.isDownloading
            ? Platform.isAndroid
                ? appText(context)
                    .strDownloading((download.progress * 1).toInt())
                : appText(context)
                    .strDownloading((download.progress * 100).toInt())
            : appText(context).strConfirmDownload,
      );
    });
  }
}

class CustomDeleteDialog extends StatelessWidget {
  const CustomDeleteDialog({
    super.key,
    required this.friendId,
    required this.docId,
    this.isUnsend = false,
  });

  final String? friendId;
  final String? docId;
  final bool isUnsend;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chat, b) {
      return CustomAdaptiveAlertDialog(
        title: appText(context).strDeleteMedia,
        actiionBtnName: appText(context).strDelete,
        alertMsg: appText(context).strConfirmDeleteMedia,
        onAction: () {
          if (isUnsend) {
            chat.unsendMessage(
              messageId: docId,
            );
          } else {
            chat.deleteChat(
              messageId: docId,
            );
          }
          Get.back();
        },
      );
    });
  }
}
