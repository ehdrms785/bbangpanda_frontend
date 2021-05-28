import 'package:bbangnarae_frontend/screens/MyPage/support/myPageApi.dart';
import 'package:get/get.dart';

import 'package:bbangnarae_frontend/shared/auth/authController.dart';

class MypageController extends GetxController {
  var isLoading = true.obs;
  // ignore: deprecated_member_use
  var userResult = Map<String, dynamic>().obs;
  @override
  void onInit() {
    if (Get.find<AuthController>().isLoggedIn.value == true) {
      fetchUserDetail();
    }
    super.onInit();
  }

  void fetchUserDetail() async {
    try {
      isLoading(true);
      final result = await MyPageApi.fetchUserDetail();
      if (result != null) {
        print(result);
        print(result.runtimeType);
        print(result.data);
        userResult.value = result.data['userDetail'];
        print(userResult);
      } else {
        print("Result 없습니다");
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
