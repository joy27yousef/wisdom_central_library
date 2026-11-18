// lib/features/pdf_reader/presentation/widgets/continue_reading_list.dart
import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/shared/widgets/build_section_header.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class _DummyBookProgress {
  final String title;
  final String author;
  final String coverUrl;
  final int currentPage;
  final int totalPages;
  final double progressPercentage;

  _DummyBookProgress({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.currentPage,
    required this.totalPages,
    required this.progressPercentage,
  });
}

class ContinueReadingList extends StatelessWidget {
  final String userId;

  const ContinueReadingList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final List<_DummyBookProgress> dummyBooks = [
      _DummyBookProgress(
        title: 'مقدمة في الذكاء الاصطناعي وتطبيقاته الحديثة',
        author: 'د. أحمد الهواري',
        coverUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
        currentPage: 45,
        totalPages: 150,
        progressPercentage: 0.30,
      ),
      _DummyBookProgress(
        title: 'فن البرمجة الهادئة وخصوصية الكود',
        author: 'روبرت مارتن',
        coverUrl:
            'https://images.unsplash.com/photo-1512820790803-83ca734da794',
        currentPage: 120,
        totalPages: 200,
        progressPercentage: 0.60,
      ),
    ];

    if (dummyBooks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        buildSectionHeader(title: 'أكمل القراءة', onSeeAll: () {}),
        const SizedBox(height: 12),
        SizedBox(
          height: 135,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 16, left: 6),
            itemCount: dummyBooks.length,
            itemBuilder: (context, index) {
              final progress = dummyBooks[index];
              final percentageInt = (progress.progressPercentage * 100).toInt();

              return GestureDetector(
                onTap: () {
                  // إجراء تجريبي عند الضغط (يمكنك إزالته أو التعديل عليه)
                },
                child: Container(
                  width: 295,
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: AppConsts.raduisMain,
                    color: AppColors.white,
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
                  child: Row(
                    children: [
                      // غلاف الكتاب
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: AppConsts.raduisMain,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: AppConsts.raduisMain,
                          child: Image.network(
                            progress.coverUrl,
                            width: 80,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // تفاصيل الكتاب وشريط التقدم
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    progress.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.prim.withValues(
                                      alpha: 0.08,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    size: 16,
                                    color: AppColors.prim,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Text(
                                progress.author,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'صفحة ${progress.currentPage} من ${progress.totalPages}',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.gray,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '$percentageInt%',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.prim,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress.progressPercentage,
                                    backgroundColor: AppColors.gray.withValues(
                                      alpha: 0.12,
                                    ),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.prim,
                                    ),
                                    minHeight: 5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
