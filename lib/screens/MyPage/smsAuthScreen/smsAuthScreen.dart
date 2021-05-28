import 'package:bbangnarae_frontend/screens/MyPage/smsAuthScreen/smsAuthController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SmsAuthScreen extends StatelessWidget {
  late final SmsAuthController smsAuthCtr = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.0.h),
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                MySliverAppBar(title: "휴대폰번호 변경"),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3.0.h),
                          child: Text(
                            "휴대폰 번호가 변경되었을 경우 새롭게 인증을 받아서 변경합니다.",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MakeGap(),
                        commonTextField(
                          label: "휴대폰 번호(숫자만 입력)",
                          controller: smsAuthCtr.phoneTextController,
                          additional: Obx(() {
                            if (smsAuthCtr.isLoading.value) {
                              return CupertinoActivityIndicator();
                            }
                            return ElevatedButton(
                              onPressed: smsAuthCtr.isSigned.value
                                  ? null
                                  : () async {
                                      if (signCodeResendTimeCheck(
                                              smsAuthCtr.resendPossibleTime) >
                                          0) return;

                                      smsAuthCtr.sendSmsCode();
                                    },
                              child: Text("인증번호 전송"),
                            );
                          }),
                        ),
                        commonTextField(
                          label: "인증번호 4자리",
                          controller: smsAuthCtr.codeTextController,
                          additional: Obx(() {
                            return ElevatedButton(
                              onPressed: smsAuthCtr.isSignCodeClicked.value
                                  ? smsAuthCtr.verifyCode
                                  : null,
                              child: Text("인증번호 확인"),
                            );
                          }),
                        ),
                        Obx(
                          () => ElevatedButton(
                            child: Text("변경하기"),
                            onPressed: smsAuthCtr.isSigned.value
                                ? () {
                                    Get.back(
                                        result: smsAuthCtr.changedPhoneNumber);
                                    showSnackBar(
                                        message:
                                            "오른쪽 상단 수정 버튼을 클릭해야 수정사항이 반영됩니다.");
                                  }
                                : null,
                          ),
                        )
                      ],
                    ),
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}
