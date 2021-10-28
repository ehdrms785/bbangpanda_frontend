import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerMainScreen/DibsDrawerMainController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showDibsDrawerModal(
    {required String title,
    required DibsDrawerMainController controller,
    required void Function() onPressed}) {
  showModalBottomSheet(
    isDismissible: true, // 위에 빈공간 눌렀을때 자동으로 없어지게 하는 기능
    isScrollControlled: true, // 풀 스크린 가능하게 만들어줌
    context: Get.context!,

    builder: (context) {
      // return Container();
      return Container(
        width: 100.0.w,
        height: 90.0.h,
        child: Column(
          children: [
            MyAppBar(title: title),
            TextField(
              onChanged: (value) {
                if (value == '') {
                  controller.drawerNameisEmpty(true);
                } else {
                  controller.drawerNameisEmpty(false);
                }
              },
              controller: controller.drawerNameTextController,
              decoration: InputDecoration(
                hintText: "서랍 이름은 최소 한 글자 이상 입력해주세요",
                counterStyle: TextStyle(fontSize: 11.0.sp, letterSpacing: 2),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
                focusedBorder:
                    new UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              autofocus: true,
              maxLength: 30,
              maxLines: 2,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: 100.0.w,
                      height: 7.0.h,
                      child: Obx(
                        () => ElevatedButton(
                            child:
                                Text("완료", style: TextStyle(fontSize: 17.0.sp)),
                            onPressed: controller.drawerNameisEmpty.value
                                ? null
                                : onPressed),
                      ))),
            ))
          ],
        ),
      );
    },
  );
}
