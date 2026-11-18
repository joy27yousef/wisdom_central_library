import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class AuthWelcomePart extends StatelessWidget {
  final String title;
  final String subTitle;
  const AuthWelcomePart({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodyLarge),
        Text(
          subTitle,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
