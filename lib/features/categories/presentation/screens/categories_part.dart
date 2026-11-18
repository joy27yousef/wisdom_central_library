import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/shared/widgets/build_section_header.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/categories/presentation/screens/all_categories_page.dart';

// نموذج بيانات مبسط للعرض الستاتيكي فقط
class _StaticCategory {
  final String id;
  final String title;

  const _StaticCategory({required this.id, required this.title});
}

class CategoriesPart extends StatelessWidget {
  const CategoriesPart({super.key});

  // بيانات تجريبية للتصنيفات الرئيسية
  static const List<_StaticCategory> _mainCategories = [
    _StaticCategory(id: 'cat_1', title: 'الأدب والرواية'),
    _StaticCategory(id: 'cat_2', title: 'البرمجة والتقنية'),
    _StaticCategory(id: 'cat_3', title: 'التاريخ والحضارة'),
    _StaticCategory(id: 'cat_4', title: 'تطوير الذات'),
    _StaticCategory(id: 'cat_5', title: 'العلوم والفيزياء'),
  ];

  @override
  Widget build(BuildContext context) {
    final displayCount = min(5, _mainCategories.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader(
          title: 'التصنيفات',
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AllCategoriesPage(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child: _mainCategories.isEmpty
              ? const Center(child: Text('لا توجد تصنيفات حالياً'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: displayCount,
                  itemBuilder: (context, index) {
                    final category = _mainCategories[index];

                    return GestureDetector(
                      onTap: () {
                        pushTo(
                          context,
                          '/categoryBooks/${category.id}',
                          category.title,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: AppConsts.raduisMain,
                          color: AppColors.prim.withValues(alpha: 0.08),
                        ),
                        child: Text(
                          category.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.prim,
                            fontWeight: FontWeight.bold,
                          ),
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
