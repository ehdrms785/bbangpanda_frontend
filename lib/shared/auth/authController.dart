import 'dart:async';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AuthController extends GetxController {
  late final StreamSubscription<ConnectivityResult> internetSubscription;

  late RxBool isLoggedIn = true.obs;
  late bool isInternetOn;
  @override
  void onInit() async {
    if (Hive.box('auth').get('token') != '' &&
        Hive.box('auth').get('refreshToken') != '') {
      print("토큰 들어있다");
      isLoggedIn((await tokenCheck()));
    } else {
      print("토큰 없다");
      isLoggedIn.value = false;
    }
    print(isLoggedIn);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      isInternetOn = false;
    } else {
      isInternetOn = true;
    }
    internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print("인터넷 체크 하는 곳 입니다요");
      print(result);
      if (result == ConnectivityResult.none) {
        isInternetOn = false;
      } else {
        isInternetOn = true;
        print(isInternetOn);
      }
    });
    super.onInit();
  }

  isLoggedInStateChange(bool value) {
    isLoggedIn.value = value;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    internetSubscription.cancel();
    super.onClose();
  }
}
