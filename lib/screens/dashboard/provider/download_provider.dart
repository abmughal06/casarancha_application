import 'dart:io';
import 'package:casarancha/utils/app_utils.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
      Get.back();
      notifyListeners();
    }
  }

  void imageDownloading(String url, String filename) async {
    isDownloading = true;
    notifyListeners();
    try {
      String path = await _getPath2(filename);

      await dio.download(
        url,
        path,
        onReceiveProgress: (count, total) {
          progress = count / total;
          notifyListeners();
        },
        deleteOnError: true,
      );

      await GallerySaver.saveImage(path, albumName: 'Casa Rancha')
          .whenComplete(() {
        GlobalSnackBar.show(message: 'Saved in Gallery');
      });
    } catch (e) {
      isDownloading = false;
      notifyListeners();
    } finally {
      isDownloading = false;
      progress = 0.0;
      Get.back();
      notifyListeners();
    }
  }

  void videoDownloading(String url, String filename, context) async {
    isDownloading = true;
    notifyListeners();
    try {
      String path = await _getPath2(filename);

      await dio.download(
        url,
        path,
        onReceiveProgress: (count, total) {
          progress = count / total;
          notifyListeners();
        },
        deleteOnError: true,
      );

      await GallerySaver.saveVideo(path, albumName: 'Casa Rancha')
          .whenComplete(() {
        GlobalSnackBar.show(message: 'Saved in Gallery');
      });
    } catch (e) {
      isDownloading = false;
      notifyListeners();
    } finally {
      isDownloading = false;
      progress = 0.0;
      Get.back();
      notifyListeners();
    }
  }

  Future<String?> downloadForShare(String url, String filename, context) async {
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
      return path;
    } catch (e) {
      return null;
    }
  }

  bool isDocOpening = false;

  Future<void> openDocument(String fileUrl, String fileName) async {
    isDocOpening = true;
    notifyListeners();
    try {
      // printLog(fileUrl);

      final response = await get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        await launchUrl(Uri.parse(fileUrl),
            mode: LaunchMode.externalApplication);
      } else {
        printLog('HTTP ERROR +==========<<>>>>>>');
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

  Future<String> _getPath2(String filename) async {
    final dir = await getTemporaryDirectory();
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
    case 'voice':
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
