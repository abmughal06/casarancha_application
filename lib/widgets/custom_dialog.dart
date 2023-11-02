import 'dart:io';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../screens/dashboard/provider/download_provider.dart';

class CustomDownloadDialog extends StatelessWidget {
  const CustomDownloadDialog({Key? key, required this.path, required this.url})
      : super(key: key);

  final String path;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(builder: (context, download, b) {
      return CupertinoAlertDialog(
        title: download.isDownloading
            ? Align(
                alignment: Alignment.center,
                child: TextWidget(
                  text: Platform.isAndroid
                      ? 'Downloading file (${(download.progress * 1).toInt()}%)'
                      : 'Downloading file (${(download.progress * 100).toInt()}%)',
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Align(
                alignment: Alignment.center,
                child: Text(
                  'Do you want to download this file?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const TextWidget(
              text: 'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              download.startDownloading(url, path, context);
              // if (!download.isDownloading) {
              //   Get.back();
              // }
            },
            child: const TextWidget(
              text: 'Yes',
            ),
          ),
        ],
      );
    });
  }
}

class CustomDeleteDialog extends StatelessWidget {
  const CustomDeleteDialog({
    Key? key,
    required this.friendId,
    required this.docId,
  }) : super(key: key);

  final String? friendId;
  final String? docId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chat, b) {
      return CupertinoAlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Are you sure you want to delete the media',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const TextWidget(
              text: 'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              chat.deleteChat(
                friendId: friendId,
                docId: docId,
              );
              Get.back();
            },
            child: const TextWidget(
              text: 'Yes',
              color: colorPrimaryA05,
            ),
          ),
        ],
      );
    });
  }
}
