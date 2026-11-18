import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_button.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/login_google.dart';

class SignupButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const SignupButton({super.key, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          isLoading: isLoading,
          color: AppColors.prim,
          ontapfun: isLoading ? () {} : onTap,
          text: 'إنشاء الحساب',
        ),
        SizedBox(height: 15),
        LoginGoogle(),
        SizedBox(height: 35),
      ],
    );
  }
}
