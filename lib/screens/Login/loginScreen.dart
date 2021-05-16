import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/Login/loginController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/query.dart';
import 'package:bbangnarae_frontend/screens/SignUp/signUpScreen.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedClass.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatelessWidget {
  final loginFormKey = GlobalKey<FormState>();
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
                      TextButton(
                          onPressed: () {
                            loginCtr.pwFocusNode.requestFocus();
                          },
                          child: Text("다음 포커스")),
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
////////// functions
  ///1620785988524 1620786179649
  Future<ErrorCode?> _signInWithServer() async {
    return Future(() async {
      String type = 'email';
      try {
        if (loginCtr.idTextController.text.startsWith('010')) {
          type = 'phone';
        }
        final result = await client.mutate(MutationOptions(
            document: gql(MyPageQuery.loginMutation),
            variables: type == 'email'
                ? {
                    'email': loginCtr.idTextController.text,
                    'password': loginCtr.passwordTextController.text
                  }
                : {
                    'phonenumber': loginCtr.idTextController.text,
                    'password': loginCtr.passwordTextController.text
                  }));
        if (result.hasException) {
          return ErrorCode(errorMessage: "로그인 접속 오류 잠시 후 다시 시도 해 주세요");
        }
        if (result.data != null) {
          final loginResult = result.data?['login'];
          if (loginResult['ok']) {
            try {
              print("로그인 완료ㅋㅋ");
              await FirebaseAuth.instance
                  .signInWithCustomToken(loginResult['customToken']);
              final token =
                  await FirebaseAuth.instance.currentUser?.getIdToken();
              Hive.box('auth').putAll({
                'token': token,
                'tokenExpired': loginResult['customTokenExpired'],
                'refreshToken': loginResult['refreshToken'],
                'refreshTokenExpired': loginResult['refreshTokenExpired']
              });
              GraphQLConfiguration.setToken(token!);
              return null;
            } catch (err) {
              print("에러발생");
              print(err);
              return null;
            }
          } else {
            final _errorBox = loginResult['error'].split('\n');
            return ErrorCode(
                errorCode: _errorBox[0], errorMessage: _errorBox[1]);
          }
        }
      } catch (e) {
        print(e);
      }
      return null;
    });
  }

  void _submit() async {
    if (this.loginFormKey.currentState!.validate()) {
      loginCtr.focusScopeNode.unfocus();
      loginCtr.isInAsyncCallStateChange(true);
      try {
        final ErrorCode? error = await _signInWithServer();
        if (error == null) {
          Get.find<AuthController>().isLoggedInStateChange(true);
        }

        if (error != null) {
          if (error.errorCode == "Error Code X00012") {
            loginCtr.focusScopeNode.requestFocus(loginCtr.pwFocusNode);
          }
          showError(title: error.errorCode, message: error.errorMessage);
          return;
        }
        Get.until((route) => route.isFirst);
        // Get.toNamed('/myPage');}
      } catch (e) {
        print(e);
        return;
      } finally {
        loginCtr.isInAsyncCallStateChange(false);
      }
    } else {
      String snackBarMesasge =
          idValidator(loginCtr.idTextController.text) ?? '';
      if (snackBarMesasge == "") {
        snackBarMesasge =
            passwordValidator(loginCtr.passwordTextController.text) ?? '';
      }
      showSnackBar(title: "로그인 실패", message: snackBarMesasge);
    }
    return;
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
        onPressed: _submit,
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
        final result = await Get.to(
          SignUpScreen(),
          transition: Transition.rightToLeft,
        );

        print(Get.currentRoute);
        print("기다리는지 체크");
        if (result != null) {
          loginCtr.idTextController.text = result;
          loginCtr.pwFocusNode.requestFocus();
        }
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
        key: this.loginFormKey, // 나중에 한꺼번에 폼필드 데이터 Save할때 사용
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
      required this.validator,
      this.isSecure = false,
      this.autoFocus = false,
      this.focusNode,
      this.labelSize,
      this.additional,
      this.useIcon = false,
      this.maxLength})
      : super(key: key);
  final bool? isSecure;
  final bool autoFocus;
  final TextEditingController controller;
  final String label;
  final FormFieldValidator validator;
  final Widget? additional;
  final bool useIcon;
  final int? maxLength;
  final FocusNode? focusNode;
  double? labelSize = 14.0.sp;

  late final ValueNotifier<bool?> isSecureNotifier = ValueNotifier(isSecure);
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
                    child: ValueListenableBuilder(
                  valueListenable: isSecureNotifier,
                  builder: (context, _isSecure, _) => TextFormField(
                    autofocus: autoFocus,
                    focusNode: focusNode,
                    style: TextStyle(fontSize: labelSize),
                    controller: controller,
                    validator: validator,
                    obscureText: _isSecure as bool,
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
                )),
              ),
              if (useIcon)
                isSecure!
                    ? secureIcon(isSecureNotifier)
                    : removeIcon(controller),
              if (additional != null) additional!
            ],
          ),
        ),
        SizedBox(height: 3.0.h),
      ],
    );
  }
}

removeIcon(TextEditingController controller) {
  return Container(
    width: 5.0.w,
    child: GestureDetector(
      onTap: () {
        controller.clear();
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(Icons.clear),
      ),
    ),
  );
}

secureIcon(ValueNotifier<bool?> isSecureNotifier) {
  return Container(
    width: 5.0.w,
    child: GestureDetector(
      onTap: () {
        isSecureNotifier.value = !isSecureNotifier.value!;
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ValueListenableBuilder(
          valueListenable: isSecureNotifier,
          builder: (context, value, child) => isSecureNotifier.value!
              ? Icon(Icons.lock_rounded)
              : Icon(Icons.lock_open_rounded),
        ),
      ),
    ),
  );
}
