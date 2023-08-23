import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadProvider extends ChangeNotifier {
  Dio dio = Dio();
  double progress = 0.0;
  bool isDownloading = false;
  File? filePath;

  void startDownloading(String url, String filename, context) async {
    isDownloading = true;
    notifyListeners();
    try {
      String path = await _getPath(filename);

      Platform.isAndroid
          ? await FileDownloader.downloadFile(
              name: filename,
              url: url,
              onProgress: (fileName, p) {
                progress = p;
                notifyListeners();
              },
            )
          : await dio.download(
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
      progress = 0.0;
      notifyListeners();
    }
  }

  Future<String> _getPath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$filename';
  }
}

String checkMediaTypeAndSetExtention(String media) {
  switch (media) {
    case 'Photo':
      return '.jpg';
    case 'InChatPic':
      return '.jpg';
    case 'Video':
      return '.MOV';
    case 'InChatVideo':
      return '.mp4';
    case 'Music':
      return '.mp3';
    case 'InChatMusic':
      return '.mp3';
    case 'InChatPDF':
      return '.pdf';
    case 'InChatDoc':
      return '.doc';
    default:
      return '.txt';
  }
}
