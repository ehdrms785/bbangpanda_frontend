import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/support/query.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SmsAuthController extends GetxController {
  late final TextEditingController codeTextController;
  late final TextEditingController phoneTextController;
  late String code;
  var resendPossibleTime = 0;
  var isSignCodeClicked = false.obs;
  String? changedPhoneNumber;
  var isLoading = false.obs;
  var isSigned = false.obs;
  @override
  void onInit() {
    phoneTextController = TextEditingController();
    codeTextController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    codeTextController.dispose();
    super.onClose();
  }

  initResendPossibleTime() {
    resendPossibleTime = (new DateTime.now().millisecondsSinceEpoch) + 30000;
  }

  void sendSmsCode() async {
    if (phoneValidator(phoneTextController.text) != null) {
      showSnackBar(message: "휴대폰 번호를 정확히 입력 해 주세요");
      return;
    }

    print("로딩");
    if (isSignCodeClicked.value) {
      if (signCodeResendTimeCheck(resendPossibleTime) > 0) return;
    } else {
      isSignCodeClicked(true);
    }
    sendSmsQueryExcute();
    initResendPossibleTime();
    print("로딩끝");
  }

  void sendSmsQueryExcute() async {
    try {
      isLoading(true);
      final String phonenumber = phoneTextController.text;

      final result = await client.mutate(
        MutationOptions(
            document: gql(MyPageQuery.sendSmsMutation),
            variables: {'phonenumber': phonenumber}),
      );
      if (result.hasException) {
        print(result.exception);
        return;
      }
      final sendSmsData = result.data!['sendSms'];
      if (sendSmsData['ok']) {
        code = sendSmsData['code'];
        changedPhoneNumber = phoneTextController.text;
        showSnackBar(message: "인증번호가 휴대폰으로 전송 되었습니다.");
      } else {
        makeErrorBoxAndShow(error: sendSmsData['error']);
      }
    } catch (err) {
      print(err);

      showError(message: "휴대폰 인증번호 전송 중 알 수 없는 유로 발생\n관리자에게 문의 해 주세요.");
    } finally {
      isLoading(false);
    }
  }

  void verifyCode() {
    print(code);
    if (code == codeTextController.text) {
      isSigned(true);
      showSnackBar(message: "인증번호가 확인 되었습니다.");
    } else {
      showSnackBar(message: "인증번호가 올바르지 않습니다.");
      return;
    }
  }
}
