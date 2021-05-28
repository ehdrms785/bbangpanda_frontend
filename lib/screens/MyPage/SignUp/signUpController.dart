import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/support/query.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedClass.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance..setLanguageCode('ko');
  final formKey = GlobalKey<FormState>();
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;
  late final TextEditingController nameTextController;
  late final TextEditingController phoneNumberTextController;
  late final TextEditingController signCodeTextController;
  late final FocusScopeNode focusScopeNode;
  late final FocusNode emailFocusNode;
  late final FocusNode pwFocusNode;
  late final FocusNode nameFocusNode;
  late final FocusNode phoneFocusNode;
  final List<String> termsList = ['이용약관에 동의합니다.', '개인정보 수집 및 이용에 동의합니다.'];

  var isSignCodeClicked = false.obs;
  var loading = false.obs;
  var resendPossibleTime = 0;
  var isInAsyncCall = false.obs;
  String verificationId = '';
  List<bool> isChecked = List.generate(2, (index) => false).obs;
  @override
  void onInit() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    nameTextController = TextEditingController();
    phoneNumberTextController = TextEditingController();
    signCodeTextController = TextEditingController();
    focusScopeNode = FocusScopeNode();
    emailFocusNode = FocusNode();
    pwFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    super.onInit();
  }

  @override
  void onClose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    nameTextController.dispose();
    phoneNumberTextController.dispose();
    signCodeTextController.dispose();
    focusScopeNode.dispose();
    emailFocusNode.dispose();
    pwFocusNode.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    super.onClose();
  }

// CommonFunction
  loadingStateChange(bool value) {
    loading.value = value;
  }

  isInAsyncCallStateChange(bool value) {
    isInAsyncCall.value = value;
  }

  initResendPossibleTime() {
    resendPossibleTime = (new DateTime.now().millisecondsSinceEpoch) + 30000;
  }

// Buisness 로직
  Future<void> signUpSubmit() async {
    return Future(() async {
      if (this.formKey.currentState!.validate()) {
        isInAsyncCallStateChange(true);
        try {
          if (isChecked.contains(false)) {
            showSnackBar(message: "이용약관을 동의 해 주세요.");
            return;
          }
          if (isSignCodeClicked.value == false) {
            showSnackBar(message: "휴대폰으로 인증번호를 보내 주세요.");
            return;
          }
          if (_auth.currentUser != null) {
            showSnackBar(message: "이미 로그인 되어 있습니다.");
            return;
          }
          final PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
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
          isInAsyncCallStateChange(false);
        }
      } else {
        String? snackBarMessage = signUpTotalValidator(
            email: emailTextController.text,
            password: passwordTextController.text,
            name: nameTextController.text,
            phonenumber: phoneNumberTextController.text,
            signCode: signCodeTextController.text);
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
        document: gql(MyPageQuery.createUserMutation),
        variables: {
          'username': nameTextController.text,
          'email': emailTextController.text,
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
            focusScopeNode.requestFocus(emailFocusNode);
            break;
          case 'Error Code X00021-2':
            focusScopeNode.requestFocus(nameFocusNode);
            break;
          case 'Error Code X00021-3':
            focusScopeNode.requestFocus(phoneFocusNode);
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

  Future<void> sendSignCode() async {
    return Future(() async {
      if (phoneValidator(phoneNumberTextController.text) != null) {
        showSnackBar(message: "휴대폰 번호를 정확히 입력 해 주세요");

        return;
      }

      if (isSignCodeClicked.value) {
        print("\n\n다시 클릭했을 때");
        if (signCodeResendTimeCheck(resendPossibleTime) > 0) return;
      } else {
        isSignCodeClicked(true);
      }
      verifyPhoneNumber(phoneNumberTextController.text);
      initResendPossibleTime();
    });
  }

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
        verificationId = verificationId;
        loadingStateChange(false);
        showSnackBar(message: "휴대폰으로 인증코드가 전송되었습니다.");
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // Auto-resolution timed out...
        verificationId = verificationId;
        print("4번");
      },
    );

    // loadingStateChange(false);
  }
}
