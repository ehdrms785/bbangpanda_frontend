import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showError({
  String title = "X00000",
  required String message,
}) {
  if (Get.isSnackbarOpen != null && Get.isSnackbarOpen == true) {
    return;
  }
  Get.snackbar(
    '',
    '',
    backgroundColor: SharedValues.mainColor.withOpacity(0.6),
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
  String title = "알림",
  required String message,
}) {
  if (Get.isSnackbarOpen != null && Get.isSnackbarOpen == true) {
    return;
  }
  Get.snackbar(
    '',
    '',
    backgroundColor: SharedValues.mainColor.withOpacity(0.6),
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
