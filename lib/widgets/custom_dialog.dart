import 'dart:io';

import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: Container(
          width: MediaQuery.of(context).size.width * .8,
          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              download.isDownloading
                  ? Align(
                      alignment: Alignment.center,
                      child: TextWidget(
                        text: Platform.isAndroid
                            ? 'Downloading file (${(download.progress * 1).toInt()}%)'
                            : 'downloading file (${(download.progress * 100).toInt()}%)',
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
              const SizedBox(height: 30),
              CommonButton(
                text: 'Download',
                showLoading: download.isDownloading,
                onTap: () {
                  download.startDownloading(url, path, context);
                },
                height: 50,
                horizontalPadding: 28,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    });
  }
}
