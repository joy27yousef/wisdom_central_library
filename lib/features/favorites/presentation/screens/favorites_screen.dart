import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

// نموذج بيانات مبسط للعرض الستاتيكي فقط
class _StaticFavoriteBook {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String publishingHouse;
  final int numbersPages;

  const _StaticFavoriteBook({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl = '',
    this.publishingHouse = 'دار الحكمة',
    this.numbersPages = 250,
  });
}

class FavoritesScreen extends StatelessWidget {
  final String userId;

  const FavoritesScreen({super.key, this.userId = 'static_user'});

  // بيانات تجريبية لقائمة الكتب المفضلة
  static const List<_StaticFavoriteBook> _favoriteBooks = [
    _StaticFavoriteBook(
      id: '1',
      title: 'Clean Code (الكود النظيف)',
      author: 'Robert C. Martin',
      publishingHouse: 'دار المعارف التقنية',
      numbersPages: 464,
    ),
    _StaticFavoriteBook(
      id: '2',
      title: 'العادات الذرية',
      author: 'جيمس كلير',
      publishingHouse: 'دار التنوير',
      numbersPages: 320,
    ),
    _StaticFavoriteBook(
      id: '3',
      title: 'مقدمة ابن خلدون',
      author: 'عبد الرحمن بن خلدون',
      publishingHouse: 'دار الحكمة للنشر',
      numbersPages: 580,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // لون الخلفية الموحد
      appBar: AppBar(
        title: Text(
          'الكتب المفضلة',
          style: AppTextStyles.headlineSmall.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA), // أببار مدمج بلون الخلفية
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () => pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.gray.withValues(alpha: 0.1)),
              ),
            ),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF1E293B),
              size: 16,
            ),
          ),
        ),
      ),
      body: _favoriteBooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.prim.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.heart_remove,
                      size: 60,
                      color: AppColors.prim.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد كتب في قائمة المفضلة حالياً',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = _favoriteBooks[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.04),
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.gray.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        pushTo(context, AppRoutes.bookDetails);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // غلاف الكتاب
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: book.coverUrl.isNotEmpty
                                    ? Image.network(
                                        book.coverUrl,
                                        width: 70,
                                        height: 95,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 70,
                                                  height: 95,
                                                  color: AppColors.prim
                                                      .withValues(alpha: 0.08),
                                                  child: const Icon(
                                                    Icons.book_rounded,
                                                    color: AppColors.prim,
                                                    size: 30,
                                                  ),
                                                ),
                                      )
                                    : Container(
                                        width: 70,
                                        height: 95,
                                        color: AppColors.prim.withValues(
                                          alpha: 0.08,
                                        ),
                                        child: const Icon(
                                          Icons.book_rounded,
                                          color: AppColors.prim,
                                          size: 30,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // معلومات الكتاب
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.gray.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.prim.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          book.publishingHouse.isNotEmpty
                                              ? book.publishingHouse
                                              : 'دار النشر',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.prim,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${book.numbersPages} صفحة',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // زر المفضلة الستاتيكي
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.heart5,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
