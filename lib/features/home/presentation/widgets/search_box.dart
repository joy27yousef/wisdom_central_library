import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppConsts.pagePaddinghz,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: AppConsts.raduisMedium,
              color: AppColors.white,
              border: Border.all(color: AppColors.gray.withValues(alpha: 0.1)),
            ),
            child: Row(
              spacing: 12,
              children: [
                Icon(Iconsax.search_normal, color: AppColors.gray, size: 20),
                Expanded(
                  child: Text(
                    'البحث عن الكتب...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.normal,
                      color: AppColors.gray,
                    ),
                  ),
                ),
                Icon(Iconsax.filter, color: AppColors.gray, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
