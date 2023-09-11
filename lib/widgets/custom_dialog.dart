import 'dart:io';

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
