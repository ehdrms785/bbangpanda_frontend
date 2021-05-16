import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/SignUp/signUpController.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/dialog/policy_dialog.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedClass.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:bbangnarae_frontend/theme/buttonTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Login/loginScreen.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

final String createUserMutation = """
  mutation createUser(\$username: String!, \$email: String!, \$phonenumber: String!, \$password: String!, \$uid: String!) {
    createUser(username: \$username, email: \$email, phonenumber: \$phonenumber, password: \$password, uid: \$uid) {
        ok
        error
        customToken
        customTokenExpired
        refreshToken
     }
  }
""";

class SignUpScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance..setLanguageCode('ko');
  final List<String> termsList = ['이용약관에 동의합니다.', '개인정보 수집 및 이용에 동의합니다.'];
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
                actions: [backToFirstRouteButton],
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
/////////// Functions
  ///

  void verifyPhoneNumber(
    String phoneNumber,
  ) async {
    if (phoneValidator(phoneNumber) != null) {
      showSnackBar(message: "휴대폰번호를 올바르게 입력 해 주세요.");
      return;
    }
    print("클릭됨");

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.replaceFirst('0', '+82'),
      timeout: const Duration(seconds: 10),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY?
        print("Recapcha 없이 인증 (안드로이드 Only)");
      },
      verificationFailed: (FirebaseAuthException err) {
        print(err.code);
        if (err.code == 'invalid-phone-number') {
          print('잘못된 휴대폰 번호 입니다.');
        }
        // 다른 오류 나면 핸들링
      },
      codeSent: (String verificationId, int? resendToken) async {
        // SMS Code 받아서
        signUpCtr.verificationId = verificationId;
        signUpCtr.loadingStateChange(false);
        showSnackBar(message: "휴대폰으로 인증코드가 전송되었습니다.");
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // Auto-resolution timed out...
        signUpCtr.verificationId = verificationId;
        print("4번");
      },
    );

    // signUpCtr.loadingStateChange(false);
  }

  Future<void> _signUpWithServer() async {
    return Future(() async {
      if (this.formKey.currentState!.validate()) {
        signUpCtr.isInAsyncCallStateChange(true);
        try {
          if (signUpCtr.isChecked.contains(false)) {
            showSnackBar(message: "이용약관을 동의 해 주세요.");
            return;
          }
          if (signUpCtr.isSignCodeClicked.value == false) {
            showSnackBar(message: "휴대폰으로 인증번호를 보내 주세요.");
            return;
          }
          if (_auth.currentUser != null) {
            showSnackBar(message: "이미 로그인 되어 있습니다.");
            return;
          }
          final PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: signUpCtr.verificationId,
            smsCode: signUpCtr.signCodeTextController.text,
          );
          await _auth.signInWithCredential(credential);

          if (_auth.currentUser != null) {
            print("유저 있음");
            bool ok = await signUpWithServer(uid: _auth.currentUser!.uid);
            print("정상 작동했나? $ok");
            await _auth.signOut();
            if (ok) {
              Get.back(result: signUpCtr.emailTextController.text);
              return;
            }
          }
        } on FirebaseAuthException catch (e) {
          print("\n\n에러발생 (아마 코드오류??)");
          print(e.code);
          if (!Get.find<AuthController>().isInternetOn) {
            showError(title: "XE00000", message: "인터넷 연결을 확인 해 주세요.");
            return;
          }
          if (e.code == "invalid-verification-id") {
            showSnackBar(message: "인증번호를 재 전송 해 주세요.");
            return;
          }
          if (e.code == "invalid-verification-code") {
            showSnackBar(message: "올바르지 않은 인증번호 입니다.");
            return;
          }
          return;
        } finally {
          signUpCtr.isInAsyncCallStateChange(false);
        }
      } else {
        String? snackBarMessage = signUpTotalValidator(
            email: signUpCtr.emailTextController.text,
            password: signUpCtr.passwordTextController.text,
            name: signUpCtr.nameTextController.text,
            phonenumber: signUpCtr.phoneNumberTextController.text,
            signCode: signUpCtr.signCodeTextController.text);
        if (snackBarMessage != null) {
          showSnackBar(title: "회원가입 실패", message: snackBarMessage);
        }
      }
    });
  }

  Future<bool> signUpWithServer({
    required String uid,
  }) async {
    try {
      final result = await client.mutate(MutationOptions(
        document: gql(createUserMutation),
        variables: {
          'username': signUpCtr.nameTextController.text,
          'email': signUpCtr.emailTextController.text,
          'phonenumber': signUpCtr.phoneNumberTextController.text,
          'password': signUpCtr.passwordTextController.text,
          'uid': uid
        },
      ));
      print('result');
      if (result.hasException) {
        print(result.exception);
        var internet = await internetCheck();
        print('interNet 상태 $internet');
        if (!await internetCheck()) {
          showError(title: "XE00000", message: "인터넷 연결을 확인 해 주세요.");
        }
        showError(
            title: "XE00001", message: '회원가입 알 수 없는 오류\n관리자에게 문의를 보내주세요.');
        return false;
      }
      final createUserResult = result.data?['createUser'];
      if (createUserResult['ok']) {
        // print(createUserResult['refreshToken']);
        // print(DateTime.now())
        Hive.box('auth').putAll({
          'refreshToken': createUserResult['refreshToken'],
          'customTokenExpired': createUserResult['customTokenExpired']
        });
        print("refershToken: ${Hive.box('auth').get('refreshToken')}");
        await _auth.signInWithCustomToken(createUserResult['customToken']);
        final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
        Hive.box('auth').put('token', idToken);
        GraphQLConfiguration.setToken(idToken!);

        // Get.offAll(Home());
        return true;
      } else {
        final _errorBox = createUserResult['error'].split('\n');
        final ErrorCode error =
            ErrorCode(errorCode: _errorBox[0], errorMessage: _errorBox[1]);
        print("계정 생성 실패");
        print(error.errorCode);
        switch (error.errorCode) {
          case 'Error Code X00021-1':
            print("헬로");
            signUpCtr.focusScopeNode.requestFocus(signUpCtr.emailFocusNode);
            break;
          case 'Error Code X00021-2':
            signUpCtr.focusScopeNode.requestFocus(signUpCtr.nameFocusNode);
            break;
          case 'Error Code X00021-3':
            signUpCtr.focusScopeNode.requestFocus(signUpCtr.phoneFocusNode);
            break;
        }
        showError(title: error.errorCode, message: error.errorMessage);
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
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
            await _signUpWithServer();
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
        key: this.formKey, // 나중에 한꺼번에 폼필드 데이터 Save할때 사용
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
            Obx(() => Padding(
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
                        Text(termsList[0]),
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
                          child: Text("본문보기"),
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
                        Text(termsList[1]),
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
                          child: Text("본문보기"),
                        )
                      ],
                    ),
                  ],
                )))
            // Obx(
            //   () => ListView.builder(
            //     shrinkWrap: true,
            //     padding: const EdgeInsets.all(0),
            //     itemCount: isChecked.length,
            //     itemBuilder: (context, index) => Container(
            //         height: 5.0.h,
            //         child: Row(
            //           children: [
            //             Checkbox(
            //               value: isChecked[index],
            //               onChanged: (value) => isChecked[index] = value!,
            //             ),
            //             Text(termsList[index]),
            //           ],
            //         )),
            //     // children: [
            //     //   Container(
            //     //     height: 5.0.h,
            //     //     child: Row(children: [],)
            //     //   )
            //     // ]
            //   ),
            // ),
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
                            if (signUpCtr.signCodeResendTimeCheck() > 0) return;
                            signUpCtr.loadingStateChange(true);
                            await sendSignCode();
                          },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero),
                      backgroundColor: elevatedButtonBackground,
                    ),
                    child: signUpCtr.loading.value
                        ? Center(child: CupertinoActivityIndicator())
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
  Future<void> sendSignCode() async {
    return Future(() async {
      if (phoneValidator(signUpCtr.phoneNumberTextController.text) != null) {
        showSnackBar(message: "휴대폰 번호를 정확히 입력 해 주세요");

        return;
      }
      final isSignCodeClicked = signUpCtr.isSignCodeClicked.value;
      if (isSignCodeClicked) {
        print("\n\n다시 클릭했을 때");
        if (signUpCtr.signCodeResendTimeCheck() > 0) return;
      } else {
        signUpCtr.isSignCodeClicked.value = true;
      }
      verifyPhoneNumber(signUpCtr.phoneNumberTextController.text);
      signUpCtr.setResendPossibleTime();
    });
  }
}

Widget backToFirstRouteButton = SizedBox(
  child: IconButton(
    icon: Icon(Icons.clear),
    iconSize: 16.0.sp,
    color: Colors.grey.shade600,
    onPressed: () {
      Get.until((route) => route.isFirst);
    },
  ),
);
