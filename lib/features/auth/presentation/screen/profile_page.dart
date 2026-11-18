import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/routes/app_routes.dart';
import 'package:wisdom_central_library/core/shared/widgets/message.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';
import 'package:wisdom_central_library/features/auth/domain/entities/user_entity.dart';
import 'package:wisdom_central_library/features/auth/presentation/managers/auth_manager.dart';

class ProfilePage extends WatchingStatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    final authManager = di<AuthManager>();
    if (authManager.currentUser.value == null ||
        authManager.currentUser.value!.uid.isEmpty) {
      authManager.checkAuthStatusCommand.run();
    }
  }

  String _cleanMessage(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final authManager = di<AuthManager>();
    final UserEntity? user = watch(authManager.currentUser).value;
    final bool isProfileComplete = watch(authManager.isProfileComplete).value;
    final bool isSigningOut = watch(authManager.signOutCommand.isRunning).value;

    registerHandler<AuthManager, void>(
      select: (m) => m.signOutCommand,
      handler: (context, _, cancel) {
        pushAndRemoveUntil(context, AppRoutes.login);
      },
    );

    registerHandler<AuthManager, CommandError<void>?>(
      select: (m) => m.signOutCommand.errors,
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الملف الشخصي', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 20),
              _buildPersonalInfoCard(
                context,
                user: user,
                showRedDot: user != null && !isProfileComplete,
              ),
              const SizedBox(height: 24),
              _buildQuickStats(),
              const SizedBox(height: 28),
              _buildSectionTitle(context, 'المكتبة والأنشطة'),
              const SizedBox(height: 12),
              _buildMenuCard(
                items: [
                  _MenuItemData(
                    icon: Icons.menu_book_rounded,
                    title: 'المكتبة',
                    subtitle: 'جميع الكتب المحفوظة في مجموعتك',
                    color: AppColors.secondary,
                    onTap: () {},
                  ),
                  _MenuItemData(
                    icon: Icons.favorite_rounded,
                    title: 'الكتب المفضلة',
                    subtitle: 'قائمة كتبك المميزة والمحببة',
                    color: const Color(0xFFFF7675),
                    onTap: () {
                      final String currentUserId = user?.uid ?? '';
                      pushTo(context, AppRoutes.favorites, currentUserId);
                    },
                  ),
                  _MenuItemData(
                    icon: Icons.download_done_rounded,
                    title: 'الكتب المحملة',
                    subtitle: 'الكتب المتاحة للقراءة بدون إنترنت',
                    color: const Color(0xFF00B894),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // قسم الإعدادات
              _buildSectionTitle(context, 'التفضيلات والحساب'),
              const SizedBox(height: 12),
              _buildMenuCard(
                items: [
                  _MenuItemData(
                    icon: Icons.tune_rounded,
                    title: 'الإعدادات',
                    subtitle: 'المظهر، التنبيهات، والخصوصية',
                    color: AppColors.prim,
                    onTap: () {},
                  ),
                  _MenuItemData(
                    icon: Iconsax.logout,
                    title: isSigningOut
                        ? 'جاري تسجيل الخروج...'
                        : 'تسجيل الخروج',
                    subtitle: 'يمكنك الدخول مجدداً عندما تريد',
                    color: const Color(0xFFFF7675),
                    onTap: isSigningOut
                        ? () {}
                        : () => authManager.signOutCommand.run(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(
    BuildContext context, {
    required UserEntity? user,
    required bool showRedDot,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppConsts.raduisMain,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.name ?? '', style: AppTextStyles.bodyLarge),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'user@example.com',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          // زر التعديل مع النقطة الحمراء (Badge)
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  pushTo(context, AppRoutes.editProfilePage);
                },
                icon: const Icon(Iconsax.user_edit, color: AppColors.prim),
                tooltip: 'تعديل البيانات',
              ),
              if (showRedDot)
                Positioned(
                  right: 8,
                  top: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppConsts.raduisMain,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatTile('24', 'المكتبة', Icons.bookmark_outline_rounded),
          _buildVerticalDivider(),
          _buildStatTile('8', 'المفضلة', Icons.favorite_border_rounded),
          _buildVerticalDivider(),
          _buildStatTile('12', 'المحملة', Icons.file_download_outlined),
        ],
      ),
    );
  }

  Widget _buildStatTile(String count, String title, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.secondary),
        const SizedBox(height: 6),
        Text(
          count,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 28,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.2),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.headlineMedium.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildMenuCard({required List<_MenuItemData> items}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppConsts.raduisMain,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppConsts.raduisMain,
        child: Column(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isLast = index == items.length - 1;

            return Column(
              children: [
                ListTile(
                  onTap: item.onTap,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    indent: 64,
                    endIndent: 16,
                    color: Colors.grey.withValues(alpha: 0.15),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
