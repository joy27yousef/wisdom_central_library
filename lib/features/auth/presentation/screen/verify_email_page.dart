import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_button.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';

class VerifyEmailPage extends WatchingWidget {
  const VerifyEmailPage({super.key});

  String _cleanMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final authManager = di<AuthManager>();

    // مراقبة حالة التحميل لكل زر بشكل مستقل
    final isChecking = watch(
      authManager.checkEmailVerifiedCommand.isExecuting,
    ).value;
    final isResending = watch(
      authManager.sendEmailVerificationCommand.isExecuting,
    ).value;

    // 1. الاستماع لنتيجة التحقق من التفعيل
    registerHandler<AuthManager, bool>(
      select: (m) => m.checkEmailVerifiedCommand,
      handler: (context, isVerified, cancel) {
        if (!isVerified) return;
        showMessage(
          context,
          message: 'تم توثيق الحساب بنجاح أهلاً بك!',
          isSuccess: true,
        );
        pushAndRemoveUntil(context, AppRoutes.main);
      },
    );

    // 2. الاستماع لأخطاء التحقق
    registerHandler<AuthManager, CommandError<void>?>(
      select: (m) => m.checkEmailVerifiedCommand.errors,
      handler: (context, error, cancel) {
        if (error == null) return;
        showMessage(
          context,
          message: _cleanMessage(error.error),
          isSuccess: false,
        );
      },
    );

    // 3. الاستماع لنجاح إعادة إرسال الرابط
    registerHandler<AuthManager, String>(
      select: (m) => m.sendEmailVerificationCommand,
      handler: (context, successMsg, cancel) {
        if (successMsg.isEmpty) return;
        showMessage(context, message: successMsg, isSuccess: true);
      },
    );

    // 4. الاستماع لأخطاء إعادة الإرسال
    registerHandler<AuthManager, CommandError<void>?>(
      select: (m) => m.sendEmailVerificationCommand.errors,
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
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'التحقق من البريد الإلكتروني',
          style: AppTextStyles.headlineSmall.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.mark_email_unread_rounded,
              size: 80,
              color: AppColors.prim,
            ),
            const SizedBox(height: 24),
            Text(
              'تحقق من بريدك الإلكتروني',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'لقد أرسلنا رابط تحقق إلى بريدك الإلكتروني. يرجى الضغط على الرابط في البريد لتفعيل حسابك ثم اضغط على زر التحقق أدناه.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.gray,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              color: AppColors.prim,
              isLoading: isChecking,
              ontapfun: () {
                authManager.checkEmailVerifiedCommand.execute();
              },
              text: 'لقد قمت بالتأكيد، متابعة',
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: isResending
                  ? null
                  : () {
                      authManager.sendEmailVerificationCommand.execute();
                    },
              child: isResending
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'إعادة إرسال رابط التحقق',
                      style: TextStyle(
                        color: AppColors.prim,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
