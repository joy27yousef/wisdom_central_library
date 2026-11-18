import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisdom_central_library/core/shared/widgets/custom_button.dart';

Future<bool> confirmationAlert(
  dynamic image,
  String content,
  String cancel,
  String confirmation,
  Color color,
  void Function() ontap,
  bool isLoading,
) {
  Get.defaultDialog(
    backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
    title: '',
    titlePadding: EdgeInsets.zero,
    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(image, height: 80),
        const SizedBox(height: 50),
        Text(
          content,
          softWrap: true,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: Theme.of(
            Get.context!,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              color: color,
              ontapfun: ontap,
              text: confirmation,
              isLoading: isLoading,
            ),

            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Text(
                cancel,
                style: Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return Future.value(true);
}
