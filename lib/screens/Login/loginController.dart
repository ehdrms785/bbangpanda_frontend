import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
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
}
