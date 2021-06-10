import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/support/query.dart';
import 'package:bbangnarae_frontend/shared/auth/authController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedClass.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  late final TextEditingController idTextController;
  late final TextEditingController passwordTextController;
  late final FocusScopeNode focusScopeNode;
  late final FocusNode pwFocusNode;
  var isSignCodeClicked = false.obs;
  var loading = false.obs;
  var resendPossibleTime = 0;
  var isInAsyncCall = false.obs;
  String verificationId = '';
  List<bool> isChecked = List.generate(2, (index) => false).obs;
  @override
  void onInit() {
    focusScopeNode = FocusScopeNode();
    pwFocusNode = FocusNode();
    idTextController = TextEditingController();
    passwordTextController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    focusScopeNode.dispose();
    pwFocusNode.dispose();
    idTextController.dispose();
    passwordTextController.dispose();
    super.onClose();
  }

// Common Logic
  loadingStateChange(bool value) {
    loading.value = value;
  }

  isInAsyncCallStateChange(bool value) {
    isInAsyncCall.value = value;
  }

  signCodeClickTrue() {
    isSignCodeClicked.value = true;
  }

  setResendPossibleTime() {
    resendPossibleTime = (new DateTime.now().millisecondsSinceEpoch) + 30000;
  }

  int signCodeResendTimeCheck() {
    int _remainSeconds =
        ((resendPossibleTime - (new DateTime.now().millisecondsSinceEpoch)) /
                1000)
            .round();
    print('_reaminSeconds: $_remainSeconds');
    if (_remainSeconds > 0 && Get.isSnackbarOpen == false) {
      showSnackBar(
          message: "인증번호 재발송은 자주 할 수 없습니다.\n$_remainSeconds 초 후에 시도 해 주세요.");
    }
    return _remainSeconds;
  }

  //Buisness Logic
  Future<ErrorCode?> signInWithServer() async {
    return Future(() async {
      String type = 'email';
      try {
        if (idTextController.text.startsWith('010')) {
          type = 'phone';
        }
        final result = await client.mutate(MutationOptions(
            document: gql(MyPageQuery.loginMutation),
            variables: type == 'email'
                ? {
                    'email': idTextController.text,
                    'password': passwordTextController.text
                  }
                : {
                    'phonenumber': idTextController.text,
                    'password': passwordTextController.text
                  }));
        if (result.hasException) {
          print(result.exception);
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

  void loginSubmit() async {
    if (loginFormKey.currentState!.validate()) {
      focusScopeNode.unfocus();
      isInAsyncCallStateChange(true);
      try {
        final ErrorCode? error = await signInWithServer();
        if (error == null) {
          Get.find<AuthController>().isLoggedInStateChange(true);
        }

        if (error != null) {
          if (error.errorCode == "Error Code X00012") {
            focusScopeNode.requestFocus(pwFocusNode);
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
        isInAsyncCallStateChange(false);
      }
    } else {
      String snackBarMesasge = idValidator(idTextController.text) ?? '';
      if (snackBarMesasge == "") {
        snackBarMesasge = passwordValidator(passwordTextController.text) ?? '';
      }
      showSnackBar(title: "로그인 실패", message: snackBarMesasge);
    }
    return;
  }
}
