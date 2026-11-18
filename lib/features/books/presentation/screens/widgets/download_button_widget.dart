import 'package:flutter/material.dart';

class DownloadButtonWidget extends StatelessWidget {
  final bool isAlreadyDownloaded;
  final double downloadProgress;
  final bool isDownloading;
  final GlobalKey buttonKey;
  final VoidCallback onStartDownload;
  final VoidCallback onOpenBook;

  const DownloadButtonWidget({
    super.key,
    required this.isAlreadyDownloaded,
    required this.downloadProgress,
    required this.isDownloading,
    required this.buttonKey,
    required this.onStartDownload,
    required this.onOpenBook,
  });

  @override
  Widget build(BuildContext context) {
    // 1. إذا كان محمل مسبقاً
    if (isAlreadyDownloaded) {
      return ElevatedButton.icon(
        onPressed: onOpenBook,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.menu_book_rounded),
        label: const Text('قراءة الكتاب (محمّل)'),
      );
    }

    // 2. إذا كان جاري التحميل حالياً
    if (isDownloading) {
      return Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: downloadProgress,
                minHeight: 50,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: downloadProgress,
                    strokeWidth: 2.5,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'جاري التحميل ${(downloadProgress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // 3. الحالة العادية (زر التحميل)
    return ElevatedButton.icon(
      key: buttonKey, // مفتاح الانطلاق للأنيميشن
      onPressed: onStartDownload,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.download_rounded),
      label: const Text('تنزيل الكتاب'),
    );
  }
}
