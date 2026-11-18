import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';
import 'package:wisdom_central_library/core/themes/app_textstyle.dart';

class CustomTextForm extends StatelessWidget {
  final String hint;
  final Icon iconform;
  final TextEditingController mycontroller;
  final TextInputType typekey;
  final String? Function(String?)? valid;
  final bool? obscureText;
  final void Function()? onTapicon;

  const CustomTextForm({
    super.key,
    required this.hint,
    required this.iconform,
    required this.mycontroller,
    required this.typekey,
    this.valid,
    this.obscureText,
    this.onTapicon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPassword =
        typekey == TextInputType.visiblePassword || obscureText != null;

    return TextFormField(
      keyboardType: typekey,
      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.normal),
      controller: mycontroller,
      obscureText: obscureText ?? false,
      validator: valid,
      cursorColor: AppColors.prim,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 170, 0, 71)),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.normal,
          color: AppColors.prim.withValues(alpha: 0.6),
        ),

        suffixIcon: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          onTap: onTapicon,
          child: isPassword
              ? Icon(
                  (obscureText ?? false)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.prim,
                )
              : iconform,
        ),
        focusColor: AppColors.prim,
        filled: true,
        fillColor: Colors
            .white, // fillColor: AppColors.accent.withValues(alpha: 0.15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.prim.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.prim, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.prim, width: 2),
        ),
      ),
    );
  }
}

Widget customDropdownField({
  required String? value,
  required String label,

  required List<String> items,
  required void Function(String?) onChanged,
  String? Function(String?)? validator,
}) {
  return DropdownButtonFormField<String>(
    initialValue: value,
    items: items.map((item) {
      return DropdownMenuItem(value: item, child: Text(item));
    }).toList(),
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.normal,
        color: AppColors.prim.withValues(alpha: 0.6),
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.prim.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.prim, width: 1.5),
      ),
    ),
  );
}
