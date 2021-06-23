import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ShowBreadsController extends GetxController
    with SingleGetTickerProviderMixin {
  ShowBreadsController(
      {required this.isShowAppBar,
      this.breadLargeCategoryId = '1',
      this.breadSmallCategoryId});

  late final RxBool isShowAppBar;
  late final String breadLargeCategoryId;
  late final String? breadSmallCategoryId;
  var isLoading = true.obs;
  var firstInitLoading = true.obs;
  var isFetchMoreLoading = false;
  var hasMore = true.obs;
  var filterLoading = true.obs;

  RxString sortFilterId = '1'.obs; // 최신순
  var filterIdList = [].obs;

  late final ScrollController scrollController;
  RxList<String> breadSortFilterIdList = ['1'].obs;
  late RxList<dynamic> breadFilterResult = [].obs;
  late RxList<String> breadOptionFilterIdList;

  RxList<dynamic> filterWidget = [].obs;
  RxInt cursorId = 0.obs;

  RxList<dynamic> tempFilterIdList = [].obs;
  var simpleBreadListResult = <BreadSimpleInfo>[].obs;

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
            !isFetchMoreLoading &&
            hasMore.value) {
          print("FetchMore 실행 !");

          Future.microtask(() => fetchMoreSimpleBreadsInfo());
        }
      }
    });

    print("1번");
    await fetchBakeryFilter();
    print("2번");
    await fetchSimpleBreadsInfo();
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

  Future<void> fetchBakeryFilter() async {
    try {
      final result = await FindPageApi.fetchBreadFilter();
      if (result != null) {
        print("여기들어왔어요");
        print(result);
        breadFilterResult =
            (result.data['getBreadFilter'] as List<Object?>).obs;

        print(breadFilterResult);
      }
    } catch (err) {
      print("에러발생용");
      print(err);
    } finally {
      filterLoading(false);
      // update(['filterBar']);
      // update(['bakeryFilerModal']);
      // print("2. FetchBakeryFilter 끝");
    }
  }

  Future<void> applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    await fetchSimpleBreadsInfo();
  }

  void initFilterSelected() {
    tempFilterIdList.clear();
    tempFilterIdList.add('1');
  }

  Future<void> refreshBakeryInfoData() async {
    hasMore(true);
    await fetchSimpleBreadsInfo();
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
            largeCategoryId: breadLargeCategoryId,
            smallCategoryId: breadSmallCategoryId);
        print("FetchSimpleBreadInfo Result");
        print(result);
        if (result != null) {
          print("크롸!");
          List<dynamic> getSimpleBreadsInfoData =
              result.data['getSimpleBreadsInfo'];
          simpleBreadListResult.clear();

          if (getSimpleBreadsInfoData.length > 0) {
            getSimpleBreadsInfoData.forEach((breadInfoJson) {
              simpleBreadListResult
                  .add(new BreadSimpleInfo.fromJson(breadInfoJson));
            });

            print(simpleBreadListResult);
            cursorId(getSimpleBreadsInfoData[getSimpleBreadsInfoData.length - 1]
                ['id']);
          }

          if (getSimpleBreadsInfoData.length == 0 ||
              getSimpleBreadsInfoData.length < SimpleBreadFetchMinimum) {
            print("SimpleBreads Fetch 한 데이터가 Minimum 이하라 hasMore : false");
            hasMore(false);
          }
        }
      } catch (err) {
        print("에러발새생");
        print(err);
      } finally {
        isLoading(false);
      }
    });
  }

  void fetchMoreSimpleBreadsInfo() async {
    try {
      print("fetchMoreSimpleBreadsInfo ~들어왔다");
      // isFetchMoreLoading(true);
      isFetchMoreLoading = true;
      print('cursorId: ${cursorId.value}');
      final result = await FindPageApi.fetchSimpleBreadsInfo(
          filterIdList: filterIdList,
          sortFilterId: sortFilterId.value,
          cursorId: cursorId.value,
          fetchMore: true);
      if (result != null) {
        print(result);
        final List<dynamic> _newSimpleBreadsInfoResult =
            result.data['getSimpleBreadsInfo'];
        // 2개가 한 번에 가져오는 데이터 양이다. (나중에 바뀔 것임)
        // 최소로 가져올 수 있는 데이터보다 양이 적다는건 더 이상 가져올 데이터가 없다는 뜻!
        // 한 번더 Rendering을 하지 않기 위해 만든 로직

        print("\n\n FetchMore SimpleBreads 데이터 보기 \n\n");

        print(_newSimpleBreadsInfoResult);
        if (_newSimpleBreadsInfoResult.length > 0) {
          _newSimpleBreadsInfoResult.forEach((breadInfoJson) {
            simpleBreadListResult
                .add(new BreadSimpleInfo.fromJson(breadInfoJson));
          });

          cursorId(_newSimpleBreadsInfoResult[
              _newSimpleBreadsInfoResult.length - 1]!['id']);
        }
        if (_newSimpleBreadsInfoResult.length < SimpleBreadFetchMinimum) {
          print("FetchMore 할 SimpleBreads 데이터가 없거나 적어서 hasMore: false 합니다");
          hasMore(false);
        }
      }
    } catch (err) {
      print("에러발새생1");
      print(err);
    } finally {
      isFetchMoreLoading = false;
    }
  }
}
