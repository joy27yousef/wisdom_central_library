import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/const/app_assets.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class AuthIconLogo extends StatelessWidget {
  const AuthIconLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 8,
        children: [
          Container(
            height: 135,
            width: 135,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppImages.iconsStKatrina),
              ),
            ),
          ),

          Text(
            "مكتبة الحكمة المركزيّة",
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.prim,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
