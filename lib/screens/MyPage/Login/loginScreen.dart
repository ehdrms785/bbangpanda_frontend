import 'package:bbangnarae_frontend/screens/MyPage/Login/loginController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/SignUp/signUpScreen.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    print("로그인 페이지 빌드");
    return Scaffold(
      body: Obx(
        () => ModalProgressScreen(
          isAsyncCall: loginCtr.isInAsyncCall.value,
          child: CustomScrollView(
            slivers: [
              MySliverAppBar(
                title: "빵판다 로그인",
              ),
              SliverToBoxAdapter(
                child: FormContainer(
                  child: Column(
                    children: [
                      MyForm(),
                      Find_Id_PW(),
                      signUpButton(),
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

//=====================
////////// Widgets
  ///
  Widget renderButton() {
    return SizedBox(
      width: 80.0.w,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: loginCtr.loginSubmit,
        child: Text(
          '로그인',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0.sp,
          ),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return GestureDetector(
      onTap: () async {
        print("버튼누름");
        print(Get.currentRoute);
        print(Get.currentRoute.runtimeType);
        print(Get.currentRoute == "/login");
        Get.to(
          SignUpScreen(),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        width: 80.0.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.3.h),
          child: Center(
            child: Text(
              '회원가입',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12.0.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget MyForm() => Form(
        key: loginCtr.loginFormKey, // 나중에 한꺼번에 폼필드 데이터 Save할때 사용
        child: TextFieldList(),
      );
  Widget Find_Id_PW() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              print("아이디 찾기 탭");
            },
            child: Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: Text(
                "아이디찾기",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12.0.sp,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("비밀번호 찾기 탭");
            },
            child: Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: Text(
                "비밀번호찾기",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12.0.sp,
                ),
              ),
            ),
          ),
        ],
      );
  Widget TextFieldList() => FocusScope(
        node: loginCtr.focusScopeNode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RenderTextFormField(
              label: '이메일 혹은 휴대폰번호 입력',
              controller: loginCtr.idTextController,
              validator: (val) {
                return idValidator(val);
              },
              autoFocus: true,
              useIcon: true,
            ),
            RenderTextFormField(
              label: '비밀번호',
              controller: loginCtr.passwordTextController,
              focusNode: loginCtr.pwFocusNode,
              isSecure: true,
              useIcon: true,
              validator: (val) {
                return passwordValidator(val);
              },
            ),
            renderButton(),
          ],
        ),
      );
}

class RenderTextFormField extends StatelessWidget {
  RenderTextFormField(
      {Key? key,
      required this.controller,
      required this.label,
      this.validator,
      this.isSecure = false,
      this.autoFocus = false,
      this.focusNode,
      this.labelSize,
      this.additional,
      this.useIcon = false,
      this.maxLength})
      : super(key: key);
  final bool isSecure;
  final bool autoFocus;
  final TextEditingController controller;
  final String label;
  final FormFieldValidator? validator;
  final Widget? additional;
  final bool useIcon;
  final int? maxLength;
  final FocusNode? focusNode;
  double? labelSize = 14.0.sp;
  late final isSecureObs = isSecure.obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  // color: Colors.red.shade100,
                  // width: additional == null ? 85.0.w : 72.0.w,
                  child: Obx(
                    () => TextFormField(
                      autofocus: autoFocus,
                      focusNode: focusNode,
                      style: TextStyle(fontSize: labelSize),
                      controller: controller,
                      validator: validator,
                      obscureText: isSecureObs.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: maxLength,
                      decoration: new InputDecoration(
                        hintText: label,
                        counterText: "",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.shade300, width: 0),
                        ),
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue),
                        ),
                        errorBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (useIcon)
                isSecure
                    ? secureTextFieldIcon(isSecureObs)
                    : removeTextFieldIcon(controller),
              if (additional != null) additional!
            ],
          ),
        ),
        SizedBox(height: 3.0.h),
      ],
    );
  }
}

class RenderTextFormField2 extends StatelessWidget {
  RenderTextFormField2(
      {Key? key,
      required this.controller,
      required this.label,
      required this.validator,
      this.isSecure = false,
      this.autoFocus = false,
      this.focusNode,
      this.labelSize,
      this.additional,
      this.useIcon = false,
      this.maxLength})
      : super(key: key);
  final bool isSecure;
  final bool autoFocus;
  final TextEditingController controller;
  final String label;
  final FormFieldValidator validator;
  final Widget? additional;
  final bool useIcon;
  final int? maxLength;
  final FocusNode? focusNode;
  double? labelSize = 14.0.sp;
  final hello = false.obs;
  late final isSecureObs = isSecure.obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: 6.0.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  // width: additional == null ? 85.0.w : 72.0.w,
                  child: Obx(
                    () => TextFormField(
                      autofocus: autoFocus,
                      focusNode: focusNode,
                      style: TextStyle(fontSize: labelSize),
                      controller: controller,
                      validator: validator,
                      obscureText: isSecureObs.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: maxLength,
                      decoration: new InputDecoration(
                        hintText: label,
                        counterText: "",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.shade300, width: 0),
                        ),
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue),
                        ),
                        errorBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (useIcon)
                isSecure
                    ? secureTextFieldIcon(isSecureObs)
                    : removeTextFieldIcon(controller),
              if (additional != null) additional!
            ],
          ),
        ),
        SizedBox(height: 3.0.h),
      ],
    );
  }
}
