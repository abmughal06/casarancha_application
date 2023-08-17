import 'package:casarancha/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../screens/dashboard/provider/download_provider.dart';

class CustomDownloadDialog extends StatelessWidget {
  const CustomDownloadDialog({Key? key, required this.path, required this.url})
      : super(key: key);

  final String path;
  final String url;

  @override
  Widget build(BuildContext context) {
    final download = context.watch<DownloadProvider>();

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
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Do you want to download this file?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 30),
            CommonButton(
              text: 'Download',
              onTap: () {
                download.startDownloading(url, path);
                Get.back();
              },
              height: 50,
              horizontalPadding: 28,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
