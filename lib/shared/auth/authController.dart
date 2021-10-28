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
      isLoggedIn((await tokenCheck()));
    } else {
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
      if (result == ConnectivityResult.none) {
        isInternetOn = false;
      } else {
        isInternetOn = true;
        print(isInternetOn);
      }
    });
    tokenExpireTest();
    super.onInit();
  }

  isLoggedInStateChange(bool value) {
    isLoggedIn.value = value;
  }

  @override
  void onClose() {
    internetSubscription.cancel();
    super.onClose();
  }

  void tokenExpireTest() {
    Future.delayed(Duration(minutes: 52), () async {
      await tokenCheck();
      tokenExpireTest();
    });
  }
}
