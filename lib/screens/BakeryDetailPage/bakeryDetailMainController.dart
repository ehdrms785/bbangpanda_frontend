// ignore_for_file: non_constant_identifier_names

import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadSharedFunctions.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:ui';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';

class BakeryDetailMainController extends GetxController
    with SingleGetTickerProviderMixin
    implements BreadModel {
  // 애니메이션
  late AnimationController ColorAnimationController;
  late AnimationController TextAnimationController;
  late Animation colorTween, iconColorTween, appBarTextColorTween;
  late Animation<double> fadeTween;
  late Animation<Offset> transTween;
  var test = true.obs;
  late final ScrollController scrollController;
  var bakeryLikeBtnShow = false.obs;
  late int bakeryId;
  late RxInt gotDibsUserCount = 0.obs;
  late RxBool isGotDibs = false.obs;
  // 추가
  late final RxString breadLargeCategoryId = '0'.obs;
  late final RxString breadSmallCategoryId = '0'.obs;

  // BakeryModel
  RxBool isLoading = true.obs;
  RxBool firstInitLoading = true.obs;
  RxBool isFetchMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxBool filterLoading = true.obs;

  late BakeryDetailInfo? bakeryDetailInfo;
  // late RxList<dynamic> bakeryFilterResult = [].obs;
  RxInt cursorBakeryId = 0.obs;
  RxString sortFilterId = '1'.obs; // 최신순
  RxList<dynamic> filterIdList = [].obs; // 제일 기본은
  RxList<dynamic> tempFilterIdList = [].obs;

  @override
  RxList breadFilterResult = [].obs;

  @override
  late RxList<String> breadOptionFilterIdList;

  @override
  late RxList<String> breadSortFilterIdList;

  @override
  RxInt cursorBreadId = 0.obs;

  @override
  RxList filterWidget = [].obs;

  @override
  var simpleBreadListResult = <BreadSimpleInfo>[].obs;

  _applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    await _fetchSimpleBreadsInfo();
  }

  applyLargeCateogryChanged(String largeCateogryId) async {
    breadLargeCategoryId(largeCateogryId);
    hasMore(true);
    await _fetchSimpleBreadsInfo();
  }

  applySmallCateogryChanged(String smallCateogryId) async {
    breadSmallCategoryId(smallCateogryId);
    hasMore(true);
    await _fetchSimpleBreadsInfo();
  }

  @override
  // TODO: implement applyFilterChanged
  get applyFilterChanged => _applyFilterChanged();

  _initFilterSelected() {
    tempFilterIdList.clear();
  }

  @override
  // TODO: implement initFilterSelected
  get initFilterSelected => _initFilterSelected();

  _refreshBakeryInfoData() async {
    hasMore(true);
    await _fetchSimpleBreadsInfo();
  }

  @override
  // TODO: implement refreshBakeryInfoData
  get refreshBakeryInfoData => _refreshBakeryInfoData();

  @override
  void onInit() async {
    bakeryId = Get.arguments['bakeryId'];
    scrollController = new ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels + 500 >=
              scrollController.position.maxScrollExtent &&
          !isFetchMoreLoading.value &&
          hasMore.value) {
        Future.microtask(() => _fetchMoreSimpleBreadsInfo());
      }
    });

    ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(ColorAnimationController);
    iconColorTween = ColorTween(begin: Colors.white, end: Colors.grey)
        .animate(ColorAnimationController);

    appBarTextColorTween =
        ColorTween(begin: Colors.transparent, end: Colors.black)
            .animate(ColorAnimationController);
    TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    fadeTween = Tween(begin: 0.0, end: 1.0).animate(ColorAnimationController);
    transTween = Tween(begin: Offset(0, 30), end: Offset(0, 0))
        .animate(TextAnimationController);

    await fetchBakeryDetail();
    breadFilterResult =
        await fetchBreadFilter(filterLoading: filterLoading) ?? [].obs;
    await _fetchSimpleBreadsInfo();
    firstInitLoading(false);
    super.onInit();
  }

  @override
  void onClose() {
    ColorAnimationController.dispose();
    TextAnimationController.dispose();
    scrollController.removeListener(() {});
    scrollController.dispose();
    // TODO: implement onClose
    super.onClose();
  }

  bool scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      var calcScrollEventAppearValue = scrollInfo.metrics.pixels / 25.0.h;
      ColorAnimationController.animateTo(calcScrollEventAppearValue);
      if (calcScrollEventAppearValue >= 1) {
        bakeryLikeBtnShow(true);
      } else {
        bakeryLikeBtnShow(false);
      }
    }
    return false;
  }

// Functions
// =======================
  Future<void> _fetchSimpleBreadsInfo() async {
    await fetchSimpleBreadsInfo(
        bakeryId: bakeryId,
        cursorBreadId: cursorBreadId,
        filterIdList: filterIdList,
        hasMore: hasMore,
        isLoading: isLoading,
        simpleBreadListResult: simpleBreadListResult,
        sortFilterId: sortFilterId,
        breadLargeCategoryId: breadLargeCategoryId.value,
        breadSmallCategoryId: breadSmallCategoryId.value);
  }

  void _fetchMoreSimpleBreadsInfo() async {
    fetchMoreSimpleBreadsInfo(
      breadLargeCategoryId: breadLargeCategoryId.value,
      breadSmallCategoryId: breadSmallCategoryId.value,
      cursorBreadId: cursorBreadId,
      filterIdList: filterIdList,
      hasMore: hasMore,
      isFetchMoreLoading: isFetchMoreLoading,
      simpleBreadListResult: simpleBreadListResult,
      sortFilterId: sortFilterId,
    );
  }

  Future<void> fetchBakeryDetail() async {
    return Future(() async {
      try {
        isLoading(true);
        print("Get에서 가져온 bakeryId : ${Get.arguments['bakeryId']}");
        final result = await FindPageApi.fetchBakeryDetail(
            bakeryId: Get.arguments['bakeryId']);
        // 가져온 데이터가 없으면 문제가 있는 것이니 에러페이지 보내기
        print(result);
        final bakeryDetailResult = result.data?['getBakeryDetail'];
        print("GetBakeryDetail Result 보기");
        print(bakeryDetailResult);
        bakeryDetailInfo = BakeryDetailInfo.fromJson(bakeryDetailResult);
        gotDibsUserCount(bakeryDetailInfo!.gotDibsUserCount).obs;
        isGotDibs(bakeryDetailInfo!.isGotDibs).obs;
      } catch (err) {
        print("에러발생");
        print(err);
      } finally {
        isLoading(false);
      }
    });
  }

  Future<void> toggleGetDibsBakery() async {
    return Future(() async {
      try {
        if (isGotDibs.value == true) {
          isGotDibs(false);
          gotDibsUserCount -= 1;
        } else {
          isGotDibs(true);
          gotDibsUserCount += 1;
        }
        final result =
            await FindPageApi.toggleGetDibsBakery(bakeryId: bakeryId);
        final toggleDibsBakeryResult = result.data?['toggleDibsBakery'];

        if (toggleDibsBakeryResult['ok'] == false) {
          showSnackBar(message: "잠시 후에 다시 시도해 주세요.");
          if (isGotDibs.value == true) {
            isGotDibs(false);
            gotDibsUserCount -= 1;
          } else {
            isGotDibs(true);
            gotDibsUserCount += 1;
          }
        }
        print(result);
      } catch (e) {
        print(e);
      }
    });
  }
}
