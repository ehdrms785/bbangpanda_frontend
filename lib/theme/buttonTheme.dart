import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final elevatedButtonBackground =
    MaterialStateProperty.resolveWith<Color>((states) {
  if (states.contains(MaterialState.disabled)) {
    return Colors.blue.shade300; // Disabled color
  }
  return Colors.blue; // Regular color
});

final textButtonRoundedBorder = TextButton.styleFrom(
  padding: EdgeInsets.all(4.0.sp),
  side: BorderSide(color: Colors.black, width: 0.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  ),
);
