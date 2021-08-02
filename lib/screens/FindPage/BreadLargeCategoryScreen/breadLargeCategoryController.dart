import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
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
  late final TabController tabController;
  late final ScrollController scrollController;
  late RxList<dynamic> breadLargeCategories = [
    {'id': 0, 'category': '전체'},
    {'id': 1, 'category': '소프트브레드'},
    {'id': 2, 'category': '하드브레드'},
    {'id': 3, 'category': '디저트'},
  ].obs;

  RxBool isShowAppBar = true.obs;
  var isLoading = true.obs;
  RxString sortFilterId = '1'.obs; // 최신순
  var filterIdList = [].obs;

  RxList<String> breadSortFilterIdList = ['1'].obs;
  late RxList<String> breadOptionFilterIdList;

  var simpleBreadListResult = <BreadSimpleInfo>[].obs;
  late List<dynamic> smallCategoriesResult = [];
  static BreadLargeCategoryController get to => Get.find();
  late BreadCategory breadLargeCategory;
  @override
  void onInit() async {
    breadLargeCategory = Get.arguments['breadLargeCategory'];
    scrollController = ScrollController();

    // 해당 LargeCategory 의 하위 SmallCategory 개수 및 데이터를 가져와야함

    await fetchBreadSmallCategories();
    tabController =
        TabController(length: smallCategoriesResult.length + 1, vsync: this);
    // await fetchSimpleBreadsInfo();
    isLoading(false);
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print("BreadLargeCategoryController 디스포스");
    scrollController.dispose();
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchBreadSmallCategories() async {
    return Future(() async {
      try {
        final result = await FindPageApi.fetchBreadSmallCategories(
            largeCategoryId: breadLargeCategory.id);

        print("FetchBreadSmallCategories Result 확인");
        print(result);
        if (result != null) {
          smallCategoriesResult = result.data['getBreadSmallCategories'];
        }
      } catch (e) {
        print('에러발새이잉이이잉');
        print(e);
      }
    });
  }

  Future<void> fetchSimpleBreadsInfo() async {
    return Future(() async {
      try {
        // print('largeCategoryId: $largeCategoryId');
        isLoading(true);
        final result = await FindPageApi.fetchSimpleBreadsInfo(
          // largeCategoryId: largeCategoryId,
          sortFilterId: sortFilterId.value,
          filterIdList: filterIdList,
        );
        print("LargetCategory Result");
        print(result);
        if (result != null) {
          print("크롸!ㅋ");
          List<dynamic> getSimpleBreadsInfoData =
              result.data['getSimpleBreadsInfo'];

          getSimpleBreadsInfoData.forEach((e) {
            simpleBreadListResult.add(
              new BreadSimpleInfo(
                id: e['id'],
                thumbnail: 'assets/breadImage.jpg',
                name: e['name'],
                bakeryName: e['bakeryName'],
                description: e['description'],
                price: e['price'],
                discount: e['discount'],
                breadFeatures: (e['breadFeatures']
                    ?.map((breadFeature) => breadFeature['filter'])).toList(),
              ),
            );
          });
        }
      } catch (e) {} finally {
        isLoading(false);
        // isLoading.value = false;
      }
    });
  }
}
