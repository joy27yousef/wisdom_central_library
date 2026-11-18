import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/features/auth/domain/entities/user_entity.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/auth_footer.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/auth_icon&logo.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/auth_welcome_part.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/login_button.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/login_inputs.dart';

class LoginPage extends WatchingStatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _cleanMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final authManager = di<AuthManager>();

    // مراقبة حالة التحميل
    final isLoading = watch(authManager.signInCommand.isRunning).value;

    // ✅ الاستماع لنجاح تسجيل الدخول
    registerHandler<AuthManager, UserEntity>(
      select: (m) => m.signInCommand,
      handler: (context, user, cancel) {
        if (user.uid.isEmpty) return;
        showMessage(context, message: 'أهلاً وسهلا بك');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            user.role == 'admin'
                ? pushWithReplacement(context, AppRoutes.main)
                : pushWithReplacement(context, AppRoutes.main);
          }
        });
      },
    );

    // ✅ الاستماع لأخطاء تسجيل الدخول
    registerHandler<AuthManager, CommandError<SignInParams>?>(
      select: (m) => m.signInCommand.errors,
      handler: (context, error, cancel) {
        if (error == null) return;
        final msg = _cleanMessage(error.error);
        showMessage(context, message: msg, isSuccess: false);

        if (msg.contains('غير موثق')) {
          authManager.sendEmailVerificationCommand.run();
          pushWithReplacement(context, AppRoutes.verifyEmail);
        }
      },
    );
    return Scaffold(
      body: Padding(
        padding: AppConsts.pagePadding,
        child: ListView(
          children: [
            const AuthIconLogo(),
            const SizedBox(height: 18),
            const AuthWelcomePart(
              title: 'أهلاً بعودتك..',
              subTitle: 'سجّل الدخول لمتابعة رحلتك الروحية والبحث في المكتبة ',
            ),
            const SizedBox(height: 18),
            LoginInputs(
              emailController: _emailController,
              passwordController: _passwordController,
            ),
            LoginButton(
              isLoading: isLoading,
              onTap: () {
                authManager.signInCommand.run(
                  SignInParams(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                );
              },
            ),
            AuthFooter(
              title: 'ليس لديك حساب ؟',
              subTitle: 'إنشاء حساب',
              ontap: () {
                pushWithReplacement(context, AppRoutes.signup);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
