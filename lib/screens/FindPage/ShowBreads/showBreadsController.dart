import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadSharedFunctions.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ShowBreadsController extends GetxController implements BreadModel {
  ShowBreadsController(
      {required this.isShowAppBar,
      this.breadLargeCategoryId = '1',
      this.breadSmallCategoryId});
  // No Override
  late final RxBool isShowAppBar;
  late final String breadLargeCategoryId;
  late final String? breadSmallCategoryId;
  //override
  RxBool isLoading = true.obs;
  RxBool firstInitLoading = true.obs;
  RxBool isFetchMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxBool filterLoading = true.obs;

  RxString sortFilterId = '1'.obs; // 최신순

  late final ScrollController scrollController;
  RxList<String> breadSortFilterIdList = ['1'].obs;
  late RxList<dynamic> breadFilterResult = [].obs;
  late RxList<String> breadOptionFilterIdList;

  RxList<dynamic> filterWidget = [].obs;
  RxInt cursorBreadId = 0.obs;

  RxList<dynamic> filterIdList = [].obs;
  RxList<dynamic> tempFilterIdList = [].obs;
  var simpleBreadListResult = <BreadSimpleInfo>[].obs;

  var isLogStateChange = false;
  @override
  void onInit() async {
    print("ShowBreadsController onInit!");

    scrollController = ScrollController();
    scrollController.addListener(() {
      print("Scroll 움직인다");
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        isShowAppBar(true);
      } else {
        isShowAppBar(false);
        if (scrollController.position.pixels + 400 >=
                scrollController.position.maxScrollExtent &&
            !isFetchMoreLoading.value &&
            hasMore.value) {
          print("FetchMore 실행 !");

          Future.microtask(() => _fetchMoreSimpleBreadsInfo());
        }
      }
    });

    print("1번");
    breadFilterResult =
        await fetchBreadFilter(filterLoading: filterLoading) ?? [].obs;
    print("2번");
    await _fetchSimpleBreadsInfo();
    print("3번");
    // fetchFilterdBakeries();
    firstInitLoading(false);
    print("4번");

    super.onInit();
  }

  @override
  void onClose() {
    print("ShowBreadsController Dispose!");
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.onClose();
  }

  void _applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    await _fetchSimpleBreadsInfo();
  }

  get applyFilterChanged => _applyFilterChanged();

  void _initFilterSelected() {
    tempFilterIdList.clear();
    tempFilterIdList.add('1');
  }

  get initFilterSelected => _initFilterSelected();

  Future<void> _refreshBakeryInfoData() async {
    hasMore(true);
    await _fetchSimpleBreadsInfo();
  }

  Future<void> get refreshBakeryInfoData => _refreshBakeryInfoData();

  Future<void> _fetchSimpleBreadsInfo() async {
    fetchSimpleBreadsInfo(
        isLoading: isLoading,
        hasMore: hasMore,
        sortFilterId: sortFilterId,
        filterIdList: filterIdList,
        breadLargeCategoryId: breadLargeCategoryId,
        breadSmallCategoryId: breadSmallCategoryId,
        simpleBreadListResult: simpleBreadListResult,
        cursorBreadId: cursorBreadId);
  }

  void _fetchMoreSimpleBreadsInfo() async {
    fetchMoreSimpleBreadsInfo(
      breadLargeCategoryId: breadLargeCategoryId,
      breadSmallCategoryId: breadSmallCategoryId,
      cursorBreadId: cursorBreadId,
      filterIdList: filterIdList,
      hasMore: hasMore,
      isFetchMoreLoading: isFetchMoreLoading,
      simpleBreadListResult: simpleBreadListResult,
      sortFilterId: sortFilterId,
    );
  }
}
