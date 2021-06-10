import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
BreadSortFilter
  1: 최신순
  2: 인기순
  3: 저가순
  4: 리뷰많은순

BreadOptionFilter
  1: 글루텐프리
  2: 쌀빵
  3: 무가당
*/

class BreadLargeCategoryController extends GetxController
    with SingleGetTickerProviderMixin {
  var categoryId = Get.parameters['categoryId'] ?? "";
  late final TabController tabController;
  late final ScrollController scrollController;

  var isShowAppBar = true.obs;
  var isLoading = true.obs;

  RxList<String> breadSortFilterIdList = ['1'].obs;
  late RxList<String> breadOptionFilterIdList;

  @override
  void onInit() {
    // 소규모 카테고리 리스트 + 전체 중에 일부 최신순으로 가져오기

    tabController = TabController(length: 4, vsync: this);
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print("디스포스");
    scrollController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
