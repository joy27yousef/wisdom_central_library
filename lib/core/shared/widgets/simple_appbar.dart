import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/routes/app_navigation.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class SimpleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool colored;

  const SimpleAppbar({super.key, required this.title, this.colored = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colored ? AppColors.prim : AppColors.background,
      centerTitle: false,
      leadingWidth: 45,
      title: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: colored ? Colors.white : Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          pop(context);
        },
        icon: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: colored ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
