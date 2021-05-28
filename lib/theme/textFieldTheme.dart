import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

TextStyle textFieldTextStyle(bool enabled) {
  return TextStyle(
      fontSize: 13.0.sp,
      color: !enabled ? Colors.grey.shade400 : null,
      fontWeight: FontWeight.w300);
}

InputDecoration textFieldInputDecoration = InputDecoration(
    counterText: "",
    contentPadding: EdgeInsets.symmetric(horizontal: 1.0.w),
    enabledBorder: new UnderlineInputBorder(
      borderSide: new BorderSide(color: Colors.grey.shade300, width: 0),
    ),
    focusedBorder: new UnderlineInputBorder(
      borderSide: new BorderSide(color: Colors.blue),
    ),
    errorBorder: new UnderlineInputBorder(
      borderSide: new BorderSide(color: Colors.red),
    ));
