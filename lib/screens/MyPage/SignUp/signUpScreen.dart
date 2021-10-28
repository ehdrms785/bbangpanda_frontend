import 'package:bbangnarae_frontend/screens/MyPage/SignUp/signUpController.dart';
import 'package:bbangnarae_frontend/shared/dialog/policy_dialog.dart';
import 'package:bbangnarae_frontend/shared/loader.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:bbangnarae_frontend/theme/buttonTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Login/loginScreen.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController signUpCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ModalProgressScreen(
          isAsyncCall: signUpCtr.isInAsyncCall.value,
          child: CustomScrollView(
            slivers: [
              MySliverAppBar(
                title: "회원가입",
                actions: [backToFirstRouteButton()],
              ),
              SliverToBoxAdapter(
                child: FormContainer(
                  child: Column(
                    children: [
                      MyForm(),
                      MakeGap(),
                      TermsList(context),
                      SignUpButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ==============
/////////// Widgets
  ///
  Widget SignUpButton() {
    return Container(
      margin: EdgeInsets.only(top: 2.0.h),
      child: SizedBox(
        width: 80.0.w,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () async {
            await signUpCtr.signUpSubmit();
          },
          child: Text(
            '회원가입',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget MyForm() => Form(
        key: signUpCtr.formKey, // 나중에 한꺼번에 폼필드 데이터 Save할때 사용
        child: TextFieldList(),
      );
  Widget TermsList(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Checkbox(
                      onChanged: (val) {
                        for (int i = 0; i < signUpCtr.isChecked.length; i++) {
                          signUpCtr.isChecked[i] = val!;
                        }
                      },
                      value: !signUpCtr.isChecked.contains(false),
                    ),
                    Text("약관 전체동의"),
                  ],
                ),
              ),
            ),
            Divider(
              indent: 0.0,
              thickness: 1.0,
              height: 0.0,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            onChanged: (val) {
                              signUpCtr.isChecked[0] = val!;
                            },
                            value: signUpCtr.isChecked[0]),
                        Text(
                          signUpCtr.termsList[0],
                          style: TextStyle(
                            fontSize: 10.0.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isDismissible: true,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              context: context,
                              builder: (context) => PolicyDialog(
                                mdFileName: "서비스 이용약관.md",
                              ),
                            );
                          },
                          child: Text("본문보기",
                              style: TextStyle(
                                fontSize: 11.0.sp,
                              )),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            onChanged: (val) {
                              signUpCtr.isChecked[1] = val!;
                            },
                            value: signUpCtr.isChecked[1]),
                        Text(
                          signUpCtr.termsList[1],
                          style: TextStyle(
                            fontSize: 10.0.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isDismissible: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => PolicyDialog(
                                mdFileName: "개인정보 처리방침.md",
                              ),
                            );
                          },
                          child: Text("본문보기",
                              style: TextStyle(
                                fontSize: 11.0.sp,
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget TextFieldList() => FocusScope(
        node: signUpCtr.focusScopeNode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RenderTextFormField(
              label: '이메일 입력',
              controller: signUpCtr.emailTextController,
              validator: (val) {
                return emailValidator(val);
              },
              focusNode: signUpCtr.emailFocusNode,
              autoFocus: true,
              useIcon: true,
            ),
            RenderTextFormField(
                label: '비밀번호 입력',
                controller: signUpCtr.passwordTextController,
                validator: (val) {
                  return passwordValidator(val);
                },
                isSecure: true,
                useIcon: true,
                focusNode: signUpCtr.pwFocusNode),
            RenderTextFormField(
                label: '이름 입력',
                controller: signUpCtr.nameTextController,
                validator: (val) {
                  return nameValidator(val);
                },
                focusNode: signUpCtr.nameFocusNode),
            RenderTextFormField(
              label: '휴대폰 번호 입력',
              controller: signUpCtr.phoneNumberTextController,
              validator: (val) {
                return phoneValidator(val);
              },
              focusNode: signUpCtr.phoneFocusNode,
              additional: Container(
                width: 20.0.w,
                height: 5.0.h,
                margin: EdgeInsets.only(left: 3.0.w),
                child: Obx(
                  () => ElevatedButton(
                    onPressed: signUpCtr.loading.value
                        ? null
                        : () async {
                            if (signCodeResendTimeCheck(
                                    signUpCtr.resendPossibleTime) >
                                0) return;
                            signUpCtr.loadingStateChange(true);
                            await signUpCtr.sendSignCode();
                          },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero),
                      backgroundColor: elevatedButtonBackground,
                    ),
                    child: signUpCtr.loading.value
                        ? Loader()
                        : Center(
                            child: Text(
                                signUpCtr.isSignCodeClicked.value
                                    ? "재전송"
                                    : "인증번호",
                                style: TextStyle(fontSize: 12.0.sp)),
                          ),
                  ),
                ),
              ),
            ),
            RenderTextFormField(
              label: '인증번호 6자리',
              controller: signUpCtr.signCodeTextController,
              maxLength: 6,
              validator: (val) {
                return signCodeValidator(val);
              },
            ),
          ],
        ),
      );

  Widget backToFirstRouteButton() => SizedBox(
        child: IconButton(
          icon: Icon(Icons.clear),
          iconSize: 16.0.sp,
          color: Colors.grey.shade600,
          onPressed: () {
            Get.until((route) => route.isFirst);
          },
        ),
      );
}
