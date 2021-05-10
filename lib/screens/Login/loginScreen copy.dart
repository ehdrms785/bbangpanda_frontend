import 'package:bbangnarae_frontend/SignUp/signUpScreen.dart';
import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/myPageScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/query.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginModal extends StatefulWidget {
  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void dispose() {
    print("디스포스~~");
    emailTextController.dispose();
    passwordTextController.dispose();

    super.dispose();
  }

  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    print("빌드 테스트");
    return Container(
      height: 90.0.h - MediaQuery.of(context).viewInsets.bottom,
      child: ModalProgressScreen(
        isAsyncCall: _isInAsyncCall,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    modalHeader(title: "빵판다 로그인"),
                    Divider(
                      indent: 0.0,
                      thickness: 2.0,
                      height: 0.0,
                    ),
                    SizedBox(height: 4.0.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                      child: Form(
                        key: this.formKey, // 나중에 한꺼번에 폼필드 데이터 Save할때 사용
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            renderTextFormField(
                                label: '이메일 혹은 휴대폰번호 입력',
                                controller: emailTextController,
                                validator: (val) {
                                  return emailValidator(val);
                                },
                                autoFocus: true),
                            renderTextFormField(
                              label: '비밀번호',
                              controller: passwordTextController,
                              isSecure: true,
                              validator: (val) {
                                return passwordValidator(val);
                              },
                            ),
                            renderButton(),
                            Row(
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
                            ),
                            Divider(
                              indent: 0.0,
                              thickness: 1.0,
                              height: 0.0,
                            ),
                            SizedBox(
                              height: 2.0.h,
                            ),
                            signInButton()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? emailValidator(String val) {
    if (val.length < 1) {
      return '이메일 혹은 휴대폰번호 입력 해 주세요';
    }
    if (RegExp(r'^010((?!@).)*$').hasMatch(val)) {
      if (!RegExp(r'^010\d{4}\d{4}').hasMatch(val)) {
        return '휴대폰번호 전체 자리를 입력 해 주세요';
      }
    } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(val)) {
      return '잘못된 이메일 형식입니다.';
    }
    return null;
  }

  String? passwordValidator(String val) {
    if (val.length < 1) {
      return '비밀번호는 필수사항입니다.';
    } else if (val.length < 8) {
      return '비밀번호는 8자 이상 입력해주세요!';
    }
    return null;
  }

  renderTextFormField({
    required TextEditingController controller,
    required String label,
    required FormFieldValidator validator,
    bool isSecure = false,
    bool autoFocus = false,
  }) {
    final ValueNotifier<bool> isSecureNotifier = ValueNotifier(isSecure);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 85.0.w,
                child: ValueListenableBuilder(
                  valueListenable: isSecureNotifier,
                  builder: (context, _isSecure, _) => TextFormField(
                    autofocus: autoFocus,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: controller,
                    validator: validator,
                    obscureText: _isSecure as bool,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: new InputDecoration(
                      hintText: label,
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
            isSecure ? secureIcon(isSecureNotifier) : removeIcon(controller),
          ],
        ),
        SizedBox(height: 3.0.h),
      ],
    );
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

  secureIcon(ValueNotifier<bool> isSecureNotifier) {
    return Container(
      width: 5.0.w,
      child: GestureDetector(
        onTap: () {
          isSecureNotifier.value = !isSecureNotifier.value;
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ValueListenableBuilder(
            valueListenable: isSecureNotifier,
            builder: (context, value, child) => isSecureNotifier.value
                ? Icon(Icons.lock_rounded)
                : Icon(Icons.lock_open_rounded),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (this.formKey.currentState!.validate()) {
      setState(() {
        _isInAsyncCall = true;
      });
      late final ErrorCode? error;
      await Future.delayed(Duration(milliseconds: 50), () async {
        error = await signInWithServer(
            emailTextController.text, passwordTextController.text);
        setState(() {
          _isInAsyncCall = false;
        });
      });

      if (error != null) {
        Get.snackbar(
          '',
          '',
          backgroundColor: Colors.white,
          titleText: Container(
            child: Center(
              child: Text(error!.errorCode),
            ),
          ),
          messageText: Container(
            child: Center(
              child: Text(error!.errorMessage),
            ),
          ),
        );
        return;
      }
      Get.to(MyPage());
      Get.snackbar(
        '로그인 성공',
        '야호',
        backgroundColor: Colors.white,
      );
    } else {
      String snackBarMesasge = emailValidator(emailTextController.text) ?? '';
      if (snackBarMesasge == "") {
        snackBarMesasge = passwordValidator(passwordTextController.text) ?? '';
      }
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.white,
        titleText: Container(
          child: Center(
            child: Text("로그인 실패"),
          ),
        ),
        messageText: Container(
          child: Center(
            child: Text(snackBarMesasge),
          ),
        ),
      );
    }
  }

  renderButton() {
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

  signInButton() {
    return GestureDetector(
      onTap: () {
        // Get.put(() => SignUpScreen());
        // Get.back();
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
}

class ErrorCode {
  ErrorCode({this.errorCode = 'X0000', required this.errorMessage});
  final String errorCode;
  final String errorMessage;

  // String? get errorCode => _errorCode;
}

Future<ErrorCode?> signInWithServer(String id, String password) async {
  String email = '';
  String phoneNumber = '';
  print('id들어옴 :$id');
  try {
    if (id.startsWith('010')) {
      print("체크");
      phoneNumber = id;
    } else {
      email = id;
    }
    final result = await client.mutate(MutationOptions(
        document: gql(MyPageQuery.loginMutation),
        variables: email.isNotEmpty
            ? {'email': email, 'password': password}
            : {'phonenumber': phoneNumber, 'password': password}));
    if (result.hasException) {
      return ErrorCode(
          errorCode: "", errorMessage: "로그인 접속 오류 잠시 후 다시 시도 해 주세요");
    }
    if (result.data != null) {
      final loginResult = result.data?['login'];
      if (loginResult['ok']) {
        try {
          print("로그인 완료");
          await FirebaseAuth.instance
              .signInWithCustomToken(loginResult['customToken']);
          final token = await FirebaseAuth.instance.currentUser?.getIdToken();
          Hive.box('auth').putAll({
            'token': token,
            'tokenExpired': loginResult['customTokenExpired'],
            'refreshToken': loginResult['refreshToken'],
            'refreshTokenExpired': loginResult['refreshTokenExpired']
          });
          GraphQLConfiguration.setToken(token!);
        } catch (err) {
          print("에러발생");
          print(err);
          return null;
        }
      } else {
        return loginResult['error'].split('\n');
      }
    }
    // FirebaseAuth.instance.signInWithCustomToken();
  } catch (e) {
    print(e);
  }
  return null;
}
