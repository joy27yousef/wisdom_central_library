import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/features/home/presentation/screens/home_page.dart';
import 'package:wisdom_central_library/features/auth/presentation/screen/profile_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final NavigationController navController = Get.put(
    NavigationController(),
    permanent: true,
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = [const HomePage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    navController.scaffoldKey = scaffoldKey;

    final primaryColor = AppColors.prim;
    final unselectedColor = AppColors.gray;

    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: navController.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.prim.withValues(alpha: 0.1),
                offset: const Offset(0, -4),
                blurRadius: 30,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAnimatedSalomonItem(
                    context: context,
                    index: 0,
                    icon: Iconsax.home_hashtag,
                    activeIcon: Iconsax.home_hashtag,
                    label: "الرئيسيّة",
                    primaryColor: primaryColor,
                    unselectedColor: unselectedColor,
                    currentIndex: navController.selectedIndex.value,
                    onTap: navController.changeIndex,
                  ),
                  _buildAnimatedSalomonItem(
                    context: context,
                    index: 1,
                    icon: Iconsax.profile_circle,
                    activeIcon: Iconsax.profile_circle,
                    label: "صفحتي الشخصية",
                    primaryColor: primaryColor,
                    unselectedColor: unselectedColor,
                    currentIndex: navController.selectedIndex.value,
                    onTap: navController.changeIndex,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSalomonItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color primaryColor,
    required Color unselectedColor,
    required int currentIndex,
    required Function(int) onTap,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey<bool>(isSelected),
                  color: isSelected ? primaryColor : unselectedColor,
                  size: isSelected ? 24 : 20,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: isSelected ? primaryColor : unselectedColor,
                  fontSize: isSelected ? 13 : 12,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;
  GlobalKey<ScaffoldState>? scaffoldKey;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void openDrawer() {
    scaffoldKey?.currentState?.openDrawer();
  }
}
