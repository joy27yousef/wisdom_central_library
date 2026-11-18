import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

Widget buildSectionHeader({
  required String title,
  required VoidCallback onSeeAll,
}) {
  return Padding(
    padding: AppConsts.pagePaddinghz,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineMedium.copyWith(fontSize: 16)),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'عرض الكل',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.prim,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    ),
  );
}
