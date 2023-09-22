import 'dart:developer';
import 'dart:io';
import 'package:casarancha/utils/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';

import 'package:path_provider/path_provider.dart';

class DownloadProvider extends ChangeNotifier {
  Dio dio = Dio();
  double progress = 0.0;
  Map<String, dynamic> documentprog = {};
  bool isDownloading = false;
  File? filePath;

  double getProgress(String link) {
    return documentprog[link] ?? 0.0;
  }

  bool isDownload(String link) {
    return documentprog.containsKey(link);
  }

  void documentDownloading(String url, String filename, context) async {
    isDownloading = true;
    documentprog[url] = 0.0;

    notifyListeners();
    try {
      String path = await _getPath(filename);

      Platform.isAndroid
          ? await FileDownloader.downloadFile(
              name: filename,
              url: url,
              onProgress: (fileName, p) {
                documentprog[url] = p;
                notifyListeners();
              },
            )
          : await dio.download(
              url,
              path,
              onReceiveProgress: (count, total) {
                documentprog[url] = count / total;
                notifyListeners();
              },
              deleteOnError: true,
            );
    } catch (e) {
      isDownloading = false;
      notifyListeners();
    } finally {
      isDownloading = false;
      documentprog[url] = 0.0;
      documentprog.remove(url);

      notifyListeners();
    }
  }

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

  // Future<void> openDocument(String filePath) async {

  //   final result = await OpenFile.open(filePath);

  //   if (result.type != ResultType.done) {
  //     print('========================================> $result');
  //   }
  // }

  bool isDocOpening = false;

  Future<void> openDocument(String fileUrl, String fileName) async {
    isDocOpening = true;
    notifyListeners();
    try {
      final response = await get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final localFilePath = join(appDocDir.path, fileName);

        final file = File(localFilePath);
        await file.writeAsBytes(response.bodyBytes);

        final result = await OpenFile.open(localFilePath);

        if (result.type != ResultType.done) {
          log('File opening Failed +==========<<>>>>>> ${result.message}');
        }
      } else {
        log('HTTP ERROR +==========<<>>>>>>');
      }
    } catch (e) {
      isDocOpening = false;
      notifyListeners();
      GlobalSnackBar.show(message: '$e');
    } finally {
      isDocOpening = false;
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
