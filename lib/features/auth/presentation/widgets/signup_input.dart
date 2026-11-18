import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_text_form.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/core/utils/validators/email_valid.dart';
import 'package:wisdom_central_library/core/utils/validators/pass_valid.dart';

class SignupInput extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController conPasswordController;
  final TextEditingController nameController;

  const SignupInput({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.conPasswordController,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text("اسم المستخدم", style: AppTextStyles.bodyMedium),
            CustomTextForm(
              mycontroller: nameController,
              hint: 'Joy',
              iconform: Icon(Icons.person, color: AppColors.prim),
              typekey: TextInputType.name,
            ),
            SizedBox(height: 8),
          ],
        ),
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
            SizedBox(height: 8),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text("التحقق من كلمة المرور ", style: AppTextStyles.bodyMedium),
            CustomTextForm(
              mycontroller: conPasswordController,
              hint: '********',
              iconform: Icon(Icons.remove_red_eye, color: AppColors.prim),
              typekey: TextInputType.visiblePassword,
              valid: (value) => PasswordValidator.validate(value ?? ''),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
