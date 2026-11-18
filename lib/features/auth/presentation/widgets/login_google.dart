import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/const/app_assets.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/auth/domain/entities/user_entity.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';

class LoginGoogle extends WatchingWidget {
  const LoginGoogle({super.key});

  String _cleanMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final authManager = di<AuthManager>();

    // مراقبة حالة التحميل الخاصة بتسجيل الدخول عبر Google فقط
    final bool isLoading = watch(
      authManager.signInWithGoogleCommand.isRunning,
    ).value;

    // 1. الاستماع لنجاح تسجيل الدخول عبر Google والتوجيه للرئيسية
    registerHandler<AuthManager, UserEntity>(
      select: (m) => m.signInWithGoogleCommand,
      handler: (context, user, cancel) {
        if (user.uid.isEmpty) return;
        showMessage(context, message: 'أهلاً وسهلا بك، ${user.name}');
        Future.delayed(const Duration(milliseconds: 400), () {
          if (context.mounted) {
            pushWithReplacement(context, AppRoutes.main);
          }
        });
      },
    );

    // 2. الاستماع لأخطاء تسجيل الدخول عبر Google
    registerHandler<AuthManager, CommandError<void>?>(
      select: (m) => m.signInWithGoogleCommand.errors,
      handler: (context, error, cancel) {
        if (error == null) return;
        showMessage(
          context,
          message: _cleanMessage(error.error),
          isSuccess: false,
        );
      },
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 2,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: AppConsts.raduisMain,
              ),
            ),
            Text(
              'أو سجّل الدخول عبر',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
            Container(
              height: 2,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: AppConsts.raduisMain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: isLoading
              ? null
              : () => authManager.signInWithGoogleCommand.run(),
          borderRadius: AppConsts.raduisMain,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.prim.withValues(alpha: 0.1),
              borderRadius: AppConsts.raduisMain,
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.prim,
                      ),
                    ),
                  )
                : Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Google',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.prim,
                        ),
                      ),
                      Image.asset(AppImages.google, width: 25),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
