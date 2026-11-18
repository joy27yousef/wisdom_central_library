import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

// نموذج بيانات مبسط للعرض الستاتيكي فقط
class _StaticCategory {
  final String id;
  final String title;

  const _StaticCategory({required this.id, required this.title});
}

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  // بيانات تجريبية للتصنيفات
  static const List<_StaticCategory> _categories = [
    _StaticCategory(id: 'cat_1', title: 'الأدب والرواية'),
    _StaticCategory(id: 'cat_2', title: 'البرمجة والتقنية'),
    _StaticCategory(id: 'cat_3', title: 'التاريخ والحضارة'),
    _StaticCategory(id: 'cat_4', title: 'تطوير الذات'),
    _StaticCategory(id: 'cat_5', title: 'العلوم والفيزياء'),
    _StaticCategory(id: 'cat_6', title: 'الفلسفة وعلم النفس'),
    _StaticCategory(id: 'cat_7', title: 'الاقتصاد وإدارة الأعمال'),
    _StaticCategory(id: 'cat_8', title: 'كتب الأطفال والناشئة'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جميع التصنيفات',
          style: AppTextStyles.headlineSmall.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => pop(context),
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.gray.withValues(alpha: 0.1)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF1E293B),
              size: 16,
            ),
          ),
        ),
      ),
      body: _categories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.folder_open,
                    size: 56,
                    color: AppColors.gray.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'لا توجد تصنيفات متاحة حالياً',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.25,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF1E293B,
                          ).withValues(alpha: 0.04),
                          blurRadius: 16,
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
                          pushTo(
                            context,
                            '/categoryBooks/${category.id}',
                            category.title,
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.prim.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Iconsax.folder_2,
                                  size: 24,
                                  color: AppColors.prim,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                category.title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFF2D3436),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
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
            ),
    );
  }
}
