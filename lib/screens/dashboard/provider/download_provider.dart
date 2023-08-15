import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../widgets/common_widgets.dart';
import '../../../widgets/text_widget.dart';

class DownloadProvider extends ChangeNotifier {
  Dio dio = Dio();
  double progress = 0.0;
  bool isDownloading = false;
  File? filePath;

  void startDownloading(String url, String filename) async {
    isDownloading = true;
    notifyListeners();
    try {
      String path = await _getPath(filename);

      await dio.download(
        url,
        path,
        onReceiveProgress: (count, total) {
          progress = count / total;
          notifyListeners();
        },
        deleteOnError: true,
      );
    } catch (e) {
      isDownloading = false;
      notifyListeners();
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }

  Future<String> _getPath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$filename';
  }
}

class DownloadProgressContainer extends StatelessWidget {
  const DownloadProgressContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(
      builder: (context, d, b) {
        return Container(
          height: 200.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 65),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      d.isDownloading == false
                          ? const Icon(Icons.done)
                          : centerLoader(),
                      heightBox(12.h),
                      TextWidget(
                        text:
                            'Downloading file (${(d.progress * 100).toInt()}%)',
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 25.w,
                top: 20.h,
                child: d.isDownloading == false
                    ? InkWell(
                        onTap: () {
                          Get.back();
                          d.progress = 0.0;
                        },
                        child: const Icon(Icons.close),
                      )
                    : Container(),
              )
            ],
          ),
        );
      },
    );
  }
}

String checkMediaTypeAndSetExtention(String media) {
  switch (media) {
    case 'Photo':
      return '.jpg';
    case 'Video':
      return '.MOV';
    case 'Music':
      return '.mp3';
    default:
      return '.txt';
  }
}
