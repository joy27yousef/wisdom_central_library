import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio dio;

  DownloadService({required this.dio});

  Future<String?> downloadPdf({
    required String url,
    required String fileName,
    required Function(int received, int total) onProgress,
  }) async {
    try {
      // 1. تحديد مسار التخزين في الجهاز
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      String savePath = "${directory?.path}/$fileName.pdf";

      // 2. تحميل الملف عبر Dio مع تتبع نسبة الإنجاز
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received, total);
          }
        },
      );

      return savePath;
    } catch (e) {
      throw Exception("فشل تنزيل الملف: ${e.toString()}");
    }
  }
}
