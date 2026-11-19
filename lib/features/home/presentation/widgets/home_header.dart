import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wisdom_central_library/core/const/app_assets.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart'
    show AppTextStyles;

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(top: 18, right: 18, left: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 12,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.prim.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      image: const DecorationImage(
                        image: AssetImage(AppImages.iconsStKatrina),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مكتبة الحكمة',
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'المركزيّة',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.prim.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppConsts.raduisMain,
                  ),
                ),
                icon: Icon(
                  Iconsax.notification,
                  color: AppColors.prim,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
