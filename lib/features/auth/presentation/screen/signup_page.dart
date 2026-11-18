import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/features/auth/domain/entities/user_entity.dart';
import 'package:wisdom_central_library/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/auth_footer.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/auth_icon&logo.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/auth_welcome_part.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/signup_button.dart';
import 'package:wisdom_central_library/features/auth/presentation/widgets/signup_input.dart';

class SignupPage extends WatchingStatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _conPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String _cleanMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final authManager = di<AuthManager>();

    // مراقبة حالة التحميل
    final isLoading = watch(authManager.signUpCommand.isExecuting).value;

    // الاستماع لنجاح إنشاء الحساب (ملاحظة: signUpCommand يرسل رسالة التحقق تلقائياً كما برمجناه في AuthManager)
    // ✅ الاستماع لنجاح إنشاء الحساب
    registerHandler<AuthManager, UserEntity>(
      select: (m) => m.signUpCommand,
      handler: (context, user, cancel) {
        if (user.uid.isEmpty) return;
        showMessage(context, message: 'أهلاً وسهلا بك');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            pushAndRemoveUntil(context, AppRoutes.verifyEmail);
          }
        });
      },
    );

    // ✅ الاستماع لأخطاء إنشاء الحساب
    registerHandler<AuthManager, CommandError<SignUpParams>?>(
      select: (m) => m.signUpCommand.errors,
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
      body: Padding(
        padding: AppConsts.pagePadding,
        child: ListView(
          children: [
            const AuthIconLogo(),
            const SizedBox(height: 18),
            const AuthWelcomePart(
              title: 'إنشاء حساب جديد',
              subTitle:
                  'أنشئ حسابك الان للبحث في المكتبة والاستفادة من خدماتها',
            ),
            const SizedBox(height: 18),
            SignupInput(
              emailController: _emailController,
              passwordController: _passwordController,
              conPasswordController: _conPasswordController,
              nameController: _nameController,
            ),
            const SizedBox(height: 10),
            SignupButton(
              isLoading: isLoading,
              onTap: () {
                if (_passwordController.text != _conPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("كلمتا المرور غير متطابقتين"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                authManager.signUpCommand.execute(
                  SignUpParams(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    name: _nameController.text.trim(),
                  ),
                );
              },
            ),
            AuthFooter(
              title: 'لديك حساب بالفعل ؟',
              subTitle: 'تسجيل الدخول',
              ontap: () {
                pushWithReplacement(context, AppRoutes.login);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
