import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class AuthFooter extends StatelessWidget {
  final String title;
  final String subTitle;
  final void Function() ontap;
  const AuthFooter({
    super.key,
    required this.title,
    required this.subTitle,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.prim),
        ),
        InkWell(
          borderRadius: AppConsts.raduisMain,
          onTap: ontap,
          child: Text(
            subTitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
