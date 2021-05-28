import 'package:bbangnarae_frontend/screens/MyPage/support/myPageApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  var isLoading = true.obs;
  var userResult = Map<String, dynamic>().obs;
  late final TextEditingController emailTextController;
  late final TextEditingController nameTextController;
  late final TextEditingController phoneTextController;
  String? originalEmail;
  String? originalName;
  String? originalPhone;
  var isSomeFieldChanged = false.obs;
  @override
  void onInit() {
    fetchEditUserDetail();
    emailTextController = TextEditingController();
    nameTextController = TextEditingController();
    phoneTextController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailTextController.dispose();
    nameTextController.dispose();
    phoneTextController.dispose();
    super.onClose();
  }

  void fetchEditUserDetail() async {
    try {
      isLoading(true);
      final result = await MyPageApi.fetchEditUserDetail();
      if (result != null) {
        print(result);
        print(result.data);
        userResult.value = result.data['userDetail'];
        print(userResult['email']);
        originalEmail = userResult['email'];
        originalName = userResult['username'];
        originalPhone = userResult['phonenumber'];
        emailTextController.text = originalEmail!;
        nameTextController.text = originalName!;
        phoneTextController.text = originalPhone!;
      } else {
        print("Result 없습니다");
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void setSomeFieldChange() {
    isSomeFieldChanged(((originalName != nameTextController.text) ||
        (originalEmail != emailTextController.text) ||
        (originalPhone != phoneTextController.text)));
  }

  bool isNameFiledChanged() {
    return originalName != nameTextController.text;
  }
}
