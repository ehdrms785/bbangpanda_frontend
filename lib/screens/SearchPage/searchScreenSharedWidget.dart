// ignore_for_file: non_constant_identifier_names

import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

AppBar SearchScreenAppBar(
    BuildContext context, SearchScreenController controller,
    {void Function(String)? onSubmit}) {
  return AppBar(
    toolbarHeight: 10.0.h,
    leadingWidth: 10.0.w,
    leading: backArrowButtton(),
    titleSpacing: 0,
    shadowColor: Colors.transparent,
    title: Container(
      width: 90.0.w,
      height: 6.0.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey.shade200,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(Icons.search, size: 16.0.sp),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        maxLength: 18,
                        enableSuggestions: false,
                        autocorrect: false,
                        // 밑에 주석 풀어야합니다.
                        // autofocus: true,
                        onChanged: (val) {
                          if (val.length > 0) {
                            controller.hasTermText(true);
                          } else {
                            controller.hasTermText(false);
                          }
                        },
                        onSubmitted: onSubmit,
                        decoration: new InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          counterText: "",
                          hintText: '빵이나 빵집을 검색 해 보세요!',
                          hintStyle: TextStyle(fontSize: 12.0.sp),
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        controller: controller.termTextController.value,
                        style: TextStyle(
                            fontSize: 12.0.sp, decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                  Obx(
                    () => removeTextFieldIcon(
                        controller.termTextController.value,
                        size: 14.0.sp,
                        hasText: controller.hasTermText),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 10.0.w,
            // color: Colors.red.shade200,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                // Get.until((route) => route.isFirst);
                Get.back();
              },
              child: Text(
                "취소",
                style: TextStyle(fontSize: 12.0.sp),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
