import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showError({
  required String title,
  required String message,
}) {
  Get.snackbar(
    '',
    '',
    backgroundColor: mainColor.withOpacity(0.6),
    titleText: Container(
      child: Center(
        child: Text('에러코드: $title'),
      ),
    ),
    messageText: Container(
      child: Center(
        child: Text(message),
      ),
    ),
  );
}

void showSnackBar({
  required String title,
  required String message,
}) {
  Get.snackbar(
    '',
    '',
    backgroundColor: mainColor.withOpacity(0.6),
    titleText: Container(
      child: Center(
        child: Text(title),
      ),
    ),
    messageText: Container(
      child: Center(
        child: Text(message),
      ),
    ),
  );
}
