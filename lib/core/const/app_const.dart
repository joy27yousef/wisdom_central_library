import 'package:flutter/material.dart';

class AppConsts {
  //! --------------------------------------------------------------
  //!                         padding
  //! --------------------------------------------------------------
  static const pagePadding = EdgeInsets.all(18);
  static const pagePaddinghz = EdgeInsets.symmetric(horizontal: 18);
  static const pagepadding_small = EdgeInsets.symmetric(horizontal: 10);
  static const verticalpadding = EdgeInsets.symmetric(vertical: 10);
  static const padd_marg_small = EdgeInsets.all(8);
  static const padd_marg_very_small = EdgeInsets.all(5);
  static const padd_marg = EdgeInsets.all(15);
  static const padd_button = EdgeInsets.symmetric(horizontal: 15, vertical: 5);
  static const padd_small_button = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 3,
  );

  //! --------------------------------------------------------------
  //!                         border raduis
  //! --------------------------------------------------------------
  static final raduisMain = BorderRadius.circular(15);
  static final raduisSmall = BorderRadius.circular(8);
  static final raduisMedium = BorderRadius.circular(10);
  static final raduisBig = BorderRadius.circular(30);

  // // border
  // static Border border_custom({required Color color, double? width}) =>
  //     Border.all(width: width ?? 2, color: color);
  // static final border_prim = Border.all(width: 2, color: AppColors.prim1);
  // static final border_prim_bold = Border.all(width: 3, color: AppColors.prim1);
  // static final border_green = Border.all(width: 1, color: AppColors.green);
  // static final border_green_bold = Border.all(width: 2, color: AppColors.green);

  // static final border_accent = Border.all(width: 1, color: AppColors.accent);
  // static final border_accent_bold = Border.all(
  //   width: 2,
  //   color: AppColors.accent,
  // );
  // static final border_hover_bold = Border.all(
  //   width: 2,
  //   color: Color(0xff93AAEF),
  // );
  // static final border_red = Border.all(width: 2, color: AppColors.red_dark);

  // duration
  static final Duration duration = Duration(milliseconds: 250);

  // delay
  static final int fadeinDelay = 250;

  // // custom shadow
  // static List<BoxShadow>? customShadow(Color color) => [
  //   BoxShadow(
  //     color: color.withValues(alpha: 0.3),
  //     blurRadius: 10,
  //     spreadRadius: 0,
  //     offset: Offset(0, 5),
  //   ),
  // ];

  // // boxshadow
  // static const blackshadow = [
  //   BoxShadow(
  //     color: Colors.black12,
  //     blurRadius: 10,
  //     spreadRadius: 0,
  //     offset: Offset(0, 5),
  //   ),
  // ];
  // // boxshadow
  // static final blackshadow_half = [
  //   BoxShadow(
  //     color: Colors.black.withValues(alpha: 0.02),
  //     blurRadius: 10,
  //     offset: const Offset(0, 5),
  //   ),
  // ];

  // static const redshadow = [
  //   BoxShadow(
  //     color: Color.fromARGB(100, 255, 58, 110),
  //     blurRadius: 10,
  //     spreadRadius: 0,
  //     offset: Offset(0, 0),
  //   ),
  // ];
  // static const secondshadow = [
  //   BoxShadow(
  //     color: AppColors.prim2,
  //     blurRadius: 10,
  //     spreadRadius: 0,
  //     offset: Offset(0, 0),
  //   ),
  // ];

  // // gradient
  // static const gradient_prim = LinearGradient(
  //   begin: Alignment.bottomCenter,
  //   end: Alignment.topCenter,
  //   colors: [Color(0xff0B1739), Color(0xff1F409F)],
  //   stops: [0.0, 0.4],
  // );
  // static const appbar_gradiant = LinearGradient(
  //   begin: Alignment.bottomCenter,
  //   end: Alignment.topCenter,
  //   colors: [Color(0xff242F5A), Color(0xff2D4192)],
  //   stops: [0.2, 0.6],
  // );
}
