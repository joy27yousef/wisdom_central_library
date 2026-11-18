import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_text_form.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/core/utils/validators/email_valid.dart';
import 'package:wisdom_central_library/core/utils/validators/pass_valid.dart';

class LoginInputs extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginInputs({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text("ادخل البريد الإلكتروني", style: AppTextStyles.bodyMedium),
            CustomTextForm(
              mycontroller: emailController,
              hint: 'john@gmail.com',
              iconform: Icon(Icons.email_rounded, color: AppColors.prim),
              typekey: TextInputType.emailAddress,
              valid: (value) => EmailValidator.validate(value ?? ''),
            ),
            SizedBox(height: 8),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text("ادخل كلمة المرور ", style: AppTextStyles.bodyMedium),
            CustomTextForm(
              mycontroller: passwordController,
              hint: '********',
              iconform: Icon(Icons.remove_red_eye, color: AppColors.prim),
              typekey: TextInputType.visiblePassword,
              valid: (value) => PasswordValidator.validate(value ?? ''),
            ),
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    pushTo(context, AppRoutes.forgetPass);
                  },
                  child: Text(
                    'نسيت كلمة المرور؟',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.prim,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
