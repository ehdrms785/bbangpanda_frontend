import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindPageScreenController extends GetxController
    with SingleGetTickerProviderMixin {
  late final TabController tabController;
  late final ScrollController scrollController;
  final RxBool isShowAppBar = true.obs;

  static FindPageScreenController get to => Get.find();
  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
