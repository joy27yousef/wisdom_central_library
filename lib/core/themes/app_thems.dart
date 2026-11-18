import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/const/app_assets.dart';
import 'package:wisdom_central_library/core/const/app_const.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class AppThems {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTextStyles.headlineSmall,
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.prim,
      primary: AppColors.prim,
      secondary: AppColors.secondary,
      surface: Colors.white,
    ),

    fontFamily: AppFonts.zain,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      showUnselectedLabels: false,
      showSelectedLabels: false,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        foregroundColor: AppColors.black,
      ),
    ),
    datePickerTheme: DatePickerThemeData(backgroundColor: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      prefixIconColor: AppColors.prim2,
      suffixIconColor: AppColors.prim2,
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.gray),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: AppColors.accent),
        borderRadius: AppConsts.raduisSmall,
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: AppColors.accent),
        borderRadius: AppConsts.raduisSmall,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: AppColors.yellow),
        borderRadius: AppConsts.raduisSmall,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: AppColors.red_half),
        borderRadius: AppConsts.raduisSmall,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: AppColors.red_half),
        borderRadius: AppConsts.raduisSmall,
      ),
    ),
  );
}
