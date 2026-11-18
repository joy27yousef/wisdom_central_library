import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wisdom_central_library/core/shared/widgets/simple_appbar.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية ستاتيكية للعرض فقط
    const String bookId = 'static_book_1';
    const String title = 'فن كتابة الكود النظيف (Clean Code)';
    const String author = 'روبرت س. مارتن';
    const String coverUrl = '';
    const bool purchase = true;
    const bool loan = true;
    const int downloadCount = 1240;
    const int favoritesCount = 385;
    const String publishingHouse = 'دار الحكمة للنشر';
    const int numbersPages = 464;
    const String publishedAt = '2024';
    const String localization = 'عربي / إنجليزي';
    const String description =
        'يُعد هذا الكتاب مرجعاً أساسياً لكل مهندس برمجيات يسعى للارتقاء بجودة الكود البرمجي الذي يكتبه، حيث يوضح المبادئ والأنماط والممارسات العملية لكتابة برمجيات نظيفة، قابلة للقراءة، وسهلة الصيانة والتطوير على المدى الطويل.';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: SimpleAppbar(title: 'تفاصيل الكتاب'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // غلاف الكتاب بتصميم ثلاثي الأبعاد بارز
                  Hero(
                    tag: bookId,
                    child: Container(
                      height: 220,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: coverUrl.isNotEmpty
                            ? Image.network(coverUrl, fit: BoxFit.cover)
                            : Container(
                                color: AppColors.prim.withValues(alpha: 0.1),
                                child: const Icon(
                                  Icons.book_rounded,
                                  size: 50,
                                  color: AppColors.prim,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // عنوان الكتاب
                  Text(
                    title.isNotEmpty ? title : 'عنوان الكتاب',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // اسم المؤلف مع أيقونة صغيرة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.user, size: 14, color: AppColors.prim),
                      const SizedBox(width: 6),
                      Text(
                        author.isNotEmpty ? author : 'اسم المؤلف',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // شارات الحالة (بيع / إعارة)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (purchase)
                        _buildModernBadge(
                          'متاح للبيع',
                          const Color(0xFF10B981),
                          Iconsax.shopping_cart,
                        ),
                      if (purchase && loan) const SizedBox(width: 8),
                      if (loan)
                        _buildModernBadge(
                          'متاح للإعارة',
                          const Color(0xFF3B82F6),
                          Iconsax.book_saved,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. محتوى تفاصيل الكتاب والبطاقات السفلية
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شريط الإحصائيات (تحميل، مفضلة)
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          Icons.download_rounded,
                          'التحميلات',
                          '$downloadCount',
                          AppColors.prim,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          Iconsax.heart5,
                          'المفضلة',
                          '$favoritesCount',
                          Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // شبكة معلومات الكتاب (دار النشر، الصفحات، التاريخ، اللغة)
                  const Text(
                    'معلومات الكتاب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoGridItem(
                          Iconsax.building,
                          'دار النشر',
                          publishingHouse.isNotEmpty
                              ? publishingHouse
                              : 'غير متوفر',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoGridItem(
                          Iconsax.book_1,
                          'عدد الصفحات',
                          '$numbersPages صفحة',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoGridItem(
                          Iconsax.calendar,
                          'تاريخ النشر',
                          publishedAt.isNotEmpty ? publishedAt : '---',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoGridItem(
                          Iconsax.global,
                          'اللغة / الموقع',
                          localization.isNotEmpty ? localization : 'عربي',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. نبذة عن الكتاب
                  const Text(
                    'نبذة عن الكتاب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      description.isNotEmpty
                          ? description
                          : 'لا يوجد وصف متاح لهذا الكتاب حالياً.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),

      // 4. شريط الأزرار السفلي الفاخر
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Iconsax.book, size: 20),
                label: const Text(
                  'ابدأ القراءة',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.prim,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            // زر طلب الشراء أو الإعارة إن كان متاحاً
            if (purchase || loan) ...[
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.prim,
                    side: BorderSide(color: AppColors.prim, width: 1.5),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    purchase ? 'طلب شراء' : 'طلب إعارة',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // شارة الحالة العصرية
  Widget _buildModernBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة إحصائيات فاخرة
  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // عنصر شبكة المعلومات
  Widget _buildInfoGridItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.prim.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.prim),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
