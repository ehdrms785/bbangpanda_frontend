import 'package:bbangnarae_frontend/screens/MyPage/SignUp/signUpController.dart';
import 'package:get/get.dart';

class SignUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignUpController());
  }
}
