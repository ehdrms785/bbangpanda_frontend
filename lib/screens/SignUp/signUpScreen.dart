import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/Home/homeScreen.dart';
import 'package:bbangnarae_frontend/screens/MyPage/myPageScreen.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Login/loginScreen.dart';

final String createUserMutation = """
  mutation createUser(\$username: String!, \$email: String!, \$phonenumber: String!, \$password: String!) {
    createUser(username: \$username, email: \$email, phonenumber: \$phonenumber, password: \$password) {
        ok
        error
        customToken
        customTokenExpired
        refreshToken
     }
  }
""";

class SignUpScreen extends StatefulWidget {
  SignUpScreen(this.controller);
  PageController controller;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var username, email, phoneNumber, password, token;
  bool _isInAsyncCall = false;
  final formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressScreen(
      isAsyncCall: _isInAsyncCall,
      child: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                "회원가입",
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              forceElevated: true,
              pinned: true,
              elevation: 1.0,
              shadowColor: Colors.black,
              leading: SizedBox(
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_sharp),
                  iconSize: 16.0.sp,
                  color: Colors.grey.shade600,
                  onPressed: () {
                    widget.controller.previousPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeOut);
                  },
                ),
              ),
              actions: [
                SizedBox(
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    iconSize: 16.0.sp,
                    color: Colors.grey.shade600,
                    onPressed: () {
                      Get.back();
                      // Get.off(MyPage());
                    },
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
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
                                RenderTextFormField(
                                  label: '이메일 입력',
                                  controller: emailTextController,
                                  validator: (val) {
                                    return emailValidator(val);
                                  },
                                  autoFocus: true,
                                  useIcon: true,
                                ),
                                RenderTextFormField(
                                  label: '비밀번호 입력',
                                  controller: passwordTextController,
                                  isSecure: true,
                                  validator: (val) {
                                    return passwordValidator(val);
                                  },
                                  useIcon: true,
                                ),
                                RenderTextFormField(
                                  label: '이름 입력',
                                  controller: nameTextController,
                                  validator: (val) {
                                    return nameValidator(val);
                                  },
                                ),
                                RenderTextFormField(
                                  label: '휴대폰 번호 입력',
                                  controller: phoneNumberTextController,
                                  validator: (val) {
                                    return phoneValidator(val);
                                  },
                                  additional: GestureDetector(
                                      onTap: () {
                                        print("인증번호 보내기");
                                      },
                                      child: Text("인증번호",
                                          style: TextStyle(fontSize: 14.0.sp))),
                                ),
                                RenderTextFormField(
                                  label: '인증번호 4자리',
                                  controller: emailTextController,
                                  validator: (val) {
                                    return emailValidator(val);
                                  },
                                ),

                                Divider(
                                  indent: 0.0,
                                  thickness: 1.0,
                                  height: 0.0,
                                ),
                                SizedBox(
                                  height: 2.0.h,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: false,
                                              onChanged: (value) {},
                                            ),
                                            Text("약관 전체동의")
                                          ],
                                        ),
                                        Divider(
                                          indent: 0.0,
                                          thickness: 1.0,
                                          height: 0.0,
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: false,
                                              onChanged: (value) {},
                                            ),
                                            Row(
                                              children: [
                                                Text("이용약관에 동의합니다"),
                                                GestureDetector(
                                                  child: Text(
                                                    "본문보기",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: false,
                                              onChanged: (value) {},
                                            ),
                                            Row(
                                              children: [
                                                Text("개인정보 수집 및 이용에 동의합니다."),
                                                GestureDetector(
                                                  child: Text(
                                                    "본문보기",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                                // signUpButton()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<UserCredential?> signUpWithServer(
    String username, String email, String phoneNumber, String password,
    [String? address]) async {
  try {
    // client.mutate(MutationOptions(document: )(
    final result = await client.mutate(MutationOptions(
      document: gql(createUserMutation),
      variables: {
        'username': username,
        'email': email,
        'address': address ?? '',
        'phonenumber': phoneNumber,
        'password': password
      },
    ));
    print('result');
    if (result.hasException) {
      print(result.exception);
      return null;
    }
    final createUserData = result.data?['createUser'];
    if (createUserData['ok']) {
      // print(createUserData['refreshToken']);
      // print(DateTime.now())
      Hive.box('auth').putAll({
        'refreshToken': createUserData['refreshToken'],
        'customTokenExpired': createUserData['customTokenExpired']
      });
      print("refershToken: ${Hive.box('auth').get('refreshToken')}");
      await FirebaseAuth.instance
          .signInWithCustomToken(createUserData['customToken']);
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      Hive.box('auth').put('token', idToken);
      GraphQLConfiguration.setToken(idToken!);

      Get.offAll(Home());
      // print(firebaseLoginResult);
      // print(idToken);
    } else {
      print("계정 생성 실패");
    }
    // ))
    // var result = await FirebaseAuth.instance.signInWithCustomToken(
    //     "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTYxOTY1NzQyMCwiZXhwIjoxNjE5NjYxMDIwLCJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay00NHlhNEBiYmFuZ25hcmFlLTQ4ODk3LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZmlyZWJhc2UtYWRtaW5zZGstNDR5YTRAYmJhbmduYXJhZS00ODg5Ny5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsInVpZCI6IjE3In0.Wd8lpc6rRdJxEr1BWu7C8qvyiL1h6KXCaByXSKFG7V2_INyVojNhx-ClkWmAls_1GHUmNCVSE5BJw8tbKKdm2WW13jL1KCfClYI8taZK1CCPyuh7qU3LTf-h7QViy1x6RCT5HQENy-TpxBHhzfLaXKmH0ihhM4tlyxhLQgQXZBcA4W78OD8KWu5ULn9GGuzZCcz-_AhNgeKMsKGZoSoorsFdR8ZVDWtE_rRFtbShbgRwxNNmV5FQMD6pq5WqxPGYpNHeV_CDlXRLn5-5yGQzutOBRHBDN_UXFpQncQ7GNnA6uHYkO43OnxLNotVG_EIQ82ahOMBU0_xrD9ddCydS1A");
    // print("헬로월드");
    // print(result);
    // FirebaseAuth.instance.signInWithCustomToken();
  } catch (e) {
    print(e);
  }
  return null;
}

String? nameValidator(String val) {
  if (val.length < 1) {
    return '이름을 입력 해 주세요';
  }
  return null;
}

String? phoneValidator(String val) {
  if (val.length < 1) {
    return '휴대폰번호 입력 해 주세요';
  }
  if (RegExp(r'^010((?!@).)*$').hasMatch(val)) {
    if (!RegExp(r'^010\d{4}\d{4}').hasMatch(val)) {
      return '휴대폰번호 전체 자리를 입력 해 주세요';
    }
  }
  return null;
}
