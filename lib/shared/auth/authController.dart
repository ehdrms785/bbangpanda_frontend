import 'dart:async';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AuthController extends GetxController {
  late final StreamSubscription<ConnectivityResult> internetSubscription;

  late RxBool isLoggedIn = true.obs;
  late bool isInternetOn;

  late final PageController mainPageController = PageController();

  static AuthController get to => Get.find();

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
    print("체크1");
    if (connectivityResult == ConnectivityResult.none) {
      isInternetOn = false;
    } else {
      isInternetOn = true;
    }
    print("체크2");

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
    print("체크3");

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
