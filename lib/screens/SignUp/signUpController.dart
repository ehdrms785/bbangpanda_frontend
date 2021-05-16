import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
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
