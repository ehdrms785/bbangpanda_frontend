import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/dialog/policy_dialog.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
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

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var username, email, phoneNumber, password, token;
  bool _isInAsyncCall = false;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance..setLanguageCode('ko');
  String _verificationId = '';
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();
  final signCodeTextController = TextEditingController();
  final ValueNotifier<bool> _isSignCodeClicked = ValueNotifier<bool>(false);
  late int resendPossibleTime;
  var _loading = false.obs;
  @override
  Widget build(BuildContext context) {
    print("회원가입 페이지 빌드");

    return Scaffold(
      body: ModalProgressScreen(
        isAsyncCall: _isInAsyncCall,
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
                    TermsList(),
                    SignUpButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ==============
/////////// Functions
  ///
  late final ConfirmationResult confirmationResult;
  void verifyPhoneNumber(
    String phoneNumber,
  ) async {
    if (phoneValidator(phoneNumber) != null) {
      Get.snackbar("알림", '휴대폰번호를 올바르게 입력 해 주세요.');
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
        print("헬로");
        _verificationId = verificationId;
        Get.snackbar("알림", "휴대폰으로 인증코드가 전송되었습니다.");
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // Auto-resolution timed out...
         _verificationId = verificationId;
        print("4번");
      },
    );
  }

  Future<void> _signUpWithServer() async {
    return Future(() async {
      if (this.formKey.currentState!.validate()) {
        setState(() {
          _isInAsyncCall = true;
        });

        if (_auth.currentUser != null) {
          Get.snackbar("알림", '이미 로그인 되어 있습니다.');
          return;
        }

        try {
          final PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verificationId,
            smsCode: signCodeTextController.text,
          );
          await _auth.signInWithCredential(credential);

          if (_auth.currentUser != null) {
            print("유저 있음");
            bool ok = await signUpWithServer(uid: _auth.currentUser!.uid);
            print("정상 작동했나? $ok");
            await _auth.signOut();
            if (ok) {
              Get.back(result: emailTextController.text);
              return;
            }
          }
        } on FirebaseAuthException catch (e) {
          print("\n\n에러발생 (아마 코드오류??)");
          print(e.code);
            if(!Get.find<AuthController>().isInternetOn) {
           showError(title: "XE00000", message: "인터넷 연결을 확인 해 주세요.");
           return;
        }
        if(e.code == "invalid-verification-id") {
                      Get.snackbar("알림", "인증번호를 재 전송 해 주세요.");
            return;
        }
          if (e.code == "invalid-verification-code") {
            Get.snackbar("알림", "올바르지 않은 인증번호 입니다.");
            return;
          }
          return;
        } finally {
          setState(() {
            _isInAsyncCall = false;
          });
        }
      } else {
        String? snackBarMessage = signUpTotalValidator(email: emailTextController.text, password: passwordTextController.text name: nameTextController.text, phonenumber: phoneNumberTextController.text, signCode: signCodeTextController.text);
        if(snackBarMessage != null) {
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
          'username': nameTextController.text,
          'email': emailTextController.text,
          // 'address': address ?? '',
          'phonenumber': phoneNumberTextController.text,
          'password': passwordTextController.text,
          'uid': uid
        },
      ));
      print('result');
      if (result.hasException) {
        print(result.exception);
        var internet = await internetCheck();
        print('interNet 상태 $internet');
        if(!await internetCheck()) {
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
        var _errorBox = createUserResult['error'].split('\n');
        print("계정 생성 실패");
        showError(title: _errorBox[0], message: _errorBox[1]);
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
    return SizedBox(
      width: 80.0.w,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () async {
          setState(() {
            _isInAsyncCall = true;
          });
          print("시작");
          await _signUpWithServer();
          print("끝");
          setState(() {
            _isInAsyncCall = false;
          });
        },
        child: Text(
          '회원가입',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0.sp,
          ),
        ),
      ),
    );
  }

  Widget MyForm() => Form(
        key: this.formKey, // 나중에 한꺼번에 폼필드 데이터 Save할때 사용
        child: TextFieldList(),
      );
  List<bool> isChecked = List.generate(2, (index) => false).obs;
  List<String> termsList = ['이용약관에 동의합니다.', '개인정보 수집 및 이용에 동의합니다.'];
  Widget TermsList() => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          children: [
            Obx(() => Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Checkbox(
                      onChanged: (val) {
                        for (int i = 0; i < isChecked.length; i++) {
                          isChecked[i] = val!;
                        }
                      },
                      value: !isChecked.contains(false),
                    ),
                    Text("약관 전체동의"),
                  ],
                ))),
            // Obx(
            //   () => CheckboxListTile(
            //     title: Text("약관 전체동의"),
            //     value: !isChecked.contains(false),
            //     contentPadding: EdgeInsets.zero,
            //     controlAffinity: ListTileControlAffinity.leading,
            //     onChanged: (val) {
            //       for (int i = 0; i < isChecked.length; i++) {
            //         isChecked[i] = val!;
            //       }
            //     },
            //   ),
            // ),
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
                              isChecked[0] = val!;
                            },
                            value: isChecked[0]),
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
                              isChecked[1] = val!;
                            },
                            value: isChecked[1]),
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

  Widget TextFieldList() => Column(
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
            additional: ValueListenableBuilder(
              valueListenable: _isSignCodeClicked,
              builder: (context, bool isCliked, _) => Container(
                width: 20.0.w,
                height: 5.0.h,
                margin: EdgeInsets.only(left: 3.0.w),
                child: ElevatedButton(
                  onPressed: () async {
                    _loading.value = true;
                    await sendSignCode(isCliked);
                    _loading.value = false;
                    // });
                  },
                  style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero)),
                  child:  Obx( () { return _loading.value == true ?Center(child: CupertinoActivityIndicator()) :Center(
                      child: Text(isCliked? "재전송" : "인증번호", style: TextStyle(fontSize: 12.0.sp)),
                    ); }
                 
                  
                
                  
                  ),
                
                ),
              ),
            ),
          ),
          RenderTextFormField(
            label: '인증번호 6자리',
            controller: signCodeTextController,
            maxLength: 6,
            validator: (val) {
              return signCodeValidator(val);
            },
          ),
        ],
      );
  Future<void> sendSignCode(bool isCliked) async {
    return Future(() async {
      if (phoneValidator(phoneNumberTextController.text) != null) {
        Get.snackbar("알림", "휴대폰 번호를 정확히 입력 해 주세요");
        return;
      }
      if (isCliked) {
        print("\n\n다시 클릭했을 때");
        int _remainSeconds = ((resendPossibleTime -
                    (new DateTime.now().millisecondsSinceEpoch)) /
                1000)
            .round();
        print('$_remainSeconds 초 !');
        if (_remainSeconds > 0) {
          Get.snackbar(
              "알림", '인증번호 재발송은 자주 할 수 없습니다.\n$_remainSeconds 초 후에 시도 해 주세요.');
          return;
        } else {
          verifyPhoneNumber(phoneNumberTextController.text);
          resendPossibleTime =
              (new DateTime.now().millisecondsSinceEpoch) + 30000;
          print('resendTime: $resendPossibleTime');
        }
      } else {
        print("\n\n클릭 처음 했을 때");
        verifyPhoneNumber(phoneNumberTextController.text);
        print("기다리는지 확인");

        resendPossibleTime =
            (new DateTime.now().millisecondsSinceEpoch) + 30000;

        _isSignCodeClicked.value = true;
      }
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
