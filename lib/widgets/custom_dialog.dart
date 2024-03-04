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
      {super.key, required this.path, required this.url});

  final String path;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(builder: (context, download, b) {
      return CustomAdaptiveAlertDialog(
        title: appText(context).strDownloadFile,
        actiionBtnName: appText(context).strYes,
        actionBtnColor: color221,
        onAction: () => download.startDownloading(url, path, context),
        alertMsg: download.isDownloading
            ? Platform.isAndroid
                ? appText(context)
                    .strDownloading((download.progress * 1).toInt())
                // 'Downloading file (${(download.progress * 1).toInt()}%)'
                : appText(context)
                    .strDownloading((download.progress * 100).toInt())
            //  'Downloading file (${(download.progress * 100).toInt()}%)'
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
  });

  final String? friendId;
  final String? docId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chat, b) {
      return CustomAdaptiveAlertDialog(
        title: appText(context).strDeleteMedia,
        actiionBtnName: appText(context).strDelete,
        alertMsg: appText(context).strConfirmDeleteMedia,
        onAction: () {
          chat.deleteChat(
            messageId: docId,
          );
          Get.back();
        },
      );
    });
  }
}
