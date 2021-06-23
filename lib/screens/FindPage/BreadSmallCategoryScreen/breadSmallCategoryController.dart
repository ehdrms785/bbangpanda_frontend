import 'package:bbangnarae_frontend/screens/FindPage/BreadLargeCategoryScreen/breadLargeCategoryController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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

class BreadSmallCategoryController extends GetxController {
  BreadSmallCategoryController({required this.largeCategory});

  var isLoading = true.obs;
  var isFetchMoreLoading = false;
  var filterLoading = true.obs;
  var firstInitLoading = true.obs;

  var hasMore = true.obs;

  final BreadLargeCategory largeCategory;
  RxList<dynamic> breadsResult = [].obs;

  late RxList<dynamic> breadFilterResult = [].obs;

  RxInt cursorId = 0.obs;
  RxString sortFilterId = '1'.obs; // 최신순
  RxList<String> filterIdList = ['1'].obs; // 제일 기본은 택배가능만 체크 된 상태
  RxList<String> tempFilterIdList = ['1'].obs;
  late final ScrollController scrollController;
  // final BreadLargeCategoryController largeCategoryController = Get.find();
  void onInit() async {
    print('${describeEnum(largeCategory)} OnInit!');

    scrollController = ScrollController();
    switch (largeCategory) {
      case BreadLargeCategory.all:
        {
          var allTest = [
            {'price': '1000', 'bakery': '전체', 'description': "전체 입니다"},
            {'price': '1100', 'bakery': '전체1', 'description': "전체1 입니다"},
            {'price': '1200', 'bakery': '전체2', 'description': "전체2 입니다"},
            {'price': '1300', 'bakery': '전체3', 'description': "전체3 입니다"},
            {'price': '1400', 'bakery': '전체4', 'description': "전체4 입니다"},
          ];
          breadsResult.addAll(allTest);
          // await Future.delayed(Duration(seconds: 3));
          isLoading(false);
        }
        break;
      case BreadLargeCategory.softBread:
        {
          var allTest = [
            {
              'price': '2000',
              'bakery': '소프트베이커리',
              'description': "소프트베이커리 입니다"
            },
            {
              'price': '2100',
              'bakery': '소프트베이커리1',
              'description': "소프트베이커리1 입니다"
            },
            {
              'price': '2200',
              'bakery': '소프트베이커리2',
              'description': "소프트베이커리2 입니다"
            },
            {
              'price': '2300',
              'bakery': '소프트베이커리3',
              'description': "소프트베이커리3 입니다"
            },
            {
              'price': '2400',
              'bakery': '소프트베이커리4',
              'description': "소프트베이커리4 입니다"
            },
          ];
          breadsResult.addAll(allTest);
          isLoading(false);
          firstInitLoading(false);
        }
        break;
      case BreadLargeCategory.hardBread:
        {}
        break;
      case BreadLargeCategory.dessert:
        {}
        break;
    }
    firstInitLoading(false);
    super.onInit();
  }

  @override
  void onClose() {
    print("dispose!");
    print('${describeEnum(largeCategory)} Dispose!');
    super.onClose();
  }

  void initFilterSelected() {
    tempFilterIdList.clear();
    tempFilterIdList.add('1');
  }

  Future<void> refreshBreadInfoData() async {
    hasMore(true);
    // await fetchSimpleBakeriesInfo();
  }

  Future<void> applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    // await fetchSimpleBakeriesInfo();
  }
}
