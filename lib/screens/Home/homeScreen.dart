import 'package:bbangnarae_frontend/screens/Login/loginScreen.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
  final formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  ValueNotifier<String> _emailInputError = ValueNotifier("");
  ValueNotifier<String> _passwordInputError = ValueNotifier("");
  String email = '';
  String password = '';
  @override
  void initState() {
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        String? validateResult = emailValidator(emailTextController.text);
        if (validateResult != null) {
          _emailInputError.value = validateResult;
        }
      } else if (_emailInputError.value != "") {
        _emailInputError.value = "";
      }
    });
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        String? validateResult = passwordValidator(passwordTextController.text);
        if (validateResult != null) {
          _passwordInputError.value = validateResult;
        }
      } else if (_passwordInputError.value != "") {
        _passwordInputError.value = "";
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

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
                        print("몇 번 Re-build 하나 봅시다");
                        return Container(
                          height:
                              90.0.h - MediaQuery.of(context).viewInsets.bottom,
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
                                                icon: Icon(
                                                    Icons.arrow_back_ios_sharp),
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
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Form(
                                          key: this
                                              .formKey, // 나중에 한꺼번에 폼필드 데이터 Save할때 사용
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              renderTextFormField(
                                                controller: emailTextController,
                                                focusNode: emailFocusNode,
                                                validator: (val) {
                                                  return emailValidator(val);
                                                },
                                                errorMessageNotifier:
                                                    _emailInputError,
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
                                                controller:
                                                    passwordTextController,
                                                focusNode: passwordFocusNode,
                                                errorMessageNotifier:
                                                    _passwordInputError,
                                                label: '비밀번호',
                                                validator: (val) {
                                                  return passwordValidator(val);
                                                },
                                                onSaved: (val) {
                                                  setState(() {
                                                    this.password = val;
                                                  });
                                                },
                                                // validator: (val) {
                                                //   return null;
                                                // },
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
    required ValueNotifier<String> errorMessageNotifier,
  }) {
    bool onTapCheck = false;

    // print("리빌드 테스트 :$errorMessage");
    ValueNotifier<bool> _showClearButton = ValueNotifier(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(children: [
          Container(
            width: _showClearButton.value ? 85.0.w : 90.0.w,
            child: ValueListenableBuilder(
              valueListenable: errorMessageNotifier,
              builder: (context, value, child) => TextFormField(
                style: TextStyle(
                  fontSize: 18.0.sp,
                ),
                controller: controller,
                focusNode: focusNode,
                validator: validator,
                onSaved: onSaved,
                onChanged: (val) {
                  print('val: $val');
                  if (val == "" && _showClearButton.value == true) {
                    _showClearButton.value = false;
                  } else {
                    if (_showClearButton.value == false)
                      _showClearButton.value = true;
                  }
                },
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  errorText: errorMessageNotifier.value,
                  hintText: label,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  isDense: true,
                ),
              ),
            ),
          ),
          // Positioned(
          //   right: 0,

          //   // color: Colors.red.shade100,
          //   child: GestureDetector(
          //     onTap: () {
          //       _showClearButton.value = false;
          //       controller.clear();
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(2.0),
          //       child: Icon(Icons.clear),
          //     ),
          //   ),
          // ),
        ]),
        SizedBox(height: 3.0.h),
      ],
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
