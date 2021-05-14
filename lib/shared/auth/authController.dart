import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AuthController extends GetxController {
  late final StreamSubscription<ConnectivityResult> subscription;
  bool? isLoggedIn = Hive.box('auth').get('isLoggedIn');
  late bool isInternetOn;
  @override
  void onInit() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      isInternetOn = false;
    } else {
      isInternetOn = true;
    }
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print("인터넷 체크 하는 곳 입니다요");
      print(result);
      if (connectivityResult == ConnectivityResult.none) {
        isInternetOn = false;
      } else {
        isInternetOn = true;
        print(isInternetOn);
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    subscription.cancel();
    super.onClose();
  }
}
