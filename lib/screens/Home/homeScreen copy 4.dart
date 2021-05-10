import 'package:bbangnarae_frontend/screens/Login/loginScreen.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final String loginMutation = """
  mutation login(\$email: String, \$phonenumber: String, \$password: String!) {
    login(email: \$email, phonenumber: \$phonenumber, password: \$password) {
        ok
        error
        token
        expiredTime
        refreshToken
     }
  }
""";

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print("빌드 리빌드 테스트");
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 20),
        child: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: () {
                  print("hello");
                })
          ],
          //AppBar Shadow를 사라져보이게 하기 !
          shadowColor: Colors.transparent,

          centerTitle: true,
          // backgroundColor: Colors.red,
          title: ValueListenableBuilder(
            valueListenable: p_appBarTitleValueNotifier,
            builder: (context, String title, _) {
              return Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0))),
                      context: context,
                      isDismissible: false,
                      isScrollControlled: true,
                      builder: (context) {
                        return LoginModal();
                      }).whenComplete(() {
                    print("모달창 닫음");
                    // Get.back();
                  });
                },
                child: Text("로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginModal extends StatefulWidget {
  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  ValueNotifier<String?> _emailInputError = ValueNotifier(null);
  ValueNotifier<String?> _passwordInputError = ValueNotifier(null);
  String email = '';
  String password = '';

  @override
  void initState() {
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        // 포커스 아웃되면 에러메세지 발생
        _emailInputError.value = emailValidator(emailTextController.text);
      } else {
        // 포커스 인 되었는데 칸이 비어있으면 에러 메세지 보내기
        if (emailTextController.text == "") {
          _emailInputError.value = emailValidator(emailTextController.text);
        }
        // 포커스 돌아왔는데 칸이 비어있는게 아니면 기존에 나있었던 에러메세지 초기화 시켜주기
        else if (_emailInputError.value != "") {
          _emailInputError.value = null;
        }
      }
    });
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        _passwordInputError.value =
            passwordValidator(passwordTextController.text);
      } else {
        if (passwordTextController.text == "") {
          _passwordInputError.value =
              passwordValidator(passwordTextController.text);
        } else if (_passwordInputError.value != "") {
          _passwordInputError.value = null;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    print("디스포스~~");
    emailFocusNode.dispose();
    emailTextController.dispose();
    passwordFocusNode.dispose();
    passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0.h - MediaQuery.of(context).viewInsets.bottom,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: 5.0.h,
                    child: Row(
                      children: [
                        SizedBox(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_sharp),
                            iconSize: 16.0.sp,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        Container(
                          width: 75.0.w,
                          child: Center(
                            child: Text(
                              "빵나래 로그인",
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
                            controller: emailTextController,
                            focusNode: emailFocusNode,
                            validator: (val) {
                              return emailValidator(val);
                            },
                            errorMessageNotifier: _emailInputError,
                            label: '이메일 혹은 휴대폰번호 입력',
                            onSaved: (val) {
                              setState(() {
                                this.email = val;
                              });
                            },
                            // validator: (val) {

                            // },
                          ),
                          renderTextFormField(
                            controller: passwordTextController,
                            focusNode: passwordFocusNode,
                            errorMessageNotifier: _passwordInputError,
                            label: '비밀번호',
                            isSecure: true,
                            validator: (val) {
                              return passwordValidator(val);
                            },
                            onSaved: (val) {
                              setState(() {
                                this.password = val;
                              });
                            },
                          ),
                          renderButton(),
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
      return '8자 이상 입력해주세요!';
    }
    return null;
  }

  renderTextFormField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required FormFieldValidator validator,
    required FormFieldSetter onSaved,
    required ValueNotifier<String?> errorMessageNotifier,
    bool isSecure = false,
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
                  valueListenable: errorMessageNotifier,
                  builder: (context, value, child) {
                    print(errorMessageNotifier.value);
                    return ValueListenableBuilder(
                      valueListenable: isSecureNotifier,
                      builder: (context, _isSecure, _) => TextFormField(
                        focusNode: focusNode,
                        controller: controller,
                        validator: validator,
                        obscureText: _isSecure as bool,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: new InputDecoration(
                          hintText: label,
                          // errorText: errorMessageNotifier.value,
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
                    );
                  }),
            ),
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

//
  renderButton() {
    return RaisedButton(
      color: Colors.blue,
      onPressed: () async {
        if (this.formKey.currentState!.validate()) {
          this.formKey.currentState!.save();

          Get.snackbar(
            '저장완료!',
            '폼 저장이 완료되었습니다!',
            backgroundColor: Colors.white,
          );
        } else {
          Get.snackbar(
            '저장실패!',
            '폼 저장이 실패했습니다',
            backgroundColor: Colors.white,
          );
        }
      },
      child: Text(
        '저장하기!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
