import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_button.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_text_form.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/core/shared/widgets/simple_appbar.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/core/utils/validators/email_valid.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';

class ForgetPassPage extends WatchingStatefulWidget {
  const ForgetPassPage({super.key});

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String _cleanMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final authManager = di<AuthManager>();

    // مراقبة حالة التحميل
    final isLoading = watch(
      authManager.sendPasswordResetCommand.isExecuting,
    ).value;

    // ✅ الاستماع لنجاح الإرسال
    registerHandler<AuthManager, String>(
      select: (m) => m.sendPasswordResetCommand,
      handler: (context, successMessage, cancel) {
        if (successMessage.isEmpty) return;
        showMessage(context, message: successMessage, isSuccess: true);
      },
    );

    // ✅ الاستماع للأخطاء
    registerHandler<AuthManager, CommandError<String>?>(
      select: (m) => m.sendPasswordResetCommand.errors,
      handler: (context, error, cancel) {
        if (error == null) return;
        showMessage(
          context,
          message: _cleanMessage(error.error),
          isSuccess: false,
        );
      },
    );

    return Scaffold(
      appBar: const SimpleAppbar(title: "إعادة تعيين كلمة المرور"),
      body: Padding(
        padding: AppConsts.pagePadding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Icon(
                  Icons.lock_reset_rounded,
                  size: 90,
                  color: AppColors.prim,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'نسيت كلمة المرور؟',
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'لا تقلق! أدخل بريدك الإلكتروني المسجل وسنرسل لك رابطاً لإعادة تعيين كلمة المرور بكل سهولة.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.normal,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextForm(
                hint: 'John@gmail.com',
                iconform: const Icon(
                  Icons.email_outlined,
                  color: AppColors.prim,
                ),
                mycontroller: _emailController,
                typekey: TextInputType.emailAddress,
                valid: (value) => EmailValidator.validate(value ?? ''),
              ),
              const SizedBox(height: 30),
              CustomButton(
                color: AppColors.prim,
                ontapfun: () {
                  if (_formKey.currentState!.validate()) {
                    authManager.sendPasswordResetCommand.execute(
                      _emailController.text.trim(),
                    );
                  }
                },
                text: 'إرسال رابط الاستعادة',
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
