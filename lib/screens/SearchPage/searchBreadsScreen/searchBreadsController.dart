import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenController.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SearchBreadsController extends GetxController implements BreadModel {
  RxBool isLoading = true.obs;
  RxBool firstInitLoading = true.obs;
  RxBool isFetchMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxBool filterLoading = true.obs;

  RxString sortFilterId = '1'.obs; // 최신순
  late RxList<dynamic> filterIdList;

  late ScrollController scrollController;
  RxList<String> breadSortFilterIdList = ['1'].obs;
  late RxList<dynamic> breadFilterResult = [].obs;
  late RxList<String> breadOptionFilterIdList;

  RxList<dynamic> filterWidget = [].obs;
  RxInt cursorBreadId = 0.obs;

  late RxList<dynamic> tempFilterIdList;
  var simpleBreadListResult = <BreadSimpleInfo>[].obs;

  @override
  void onInit() async {
    print("ShowBreadsController onInit!");

    scrollController = new ScrollController();
    scrollController.addListener(() {
      print("Scroll 움직인다");

      if (scrollController.position.pixels + 400 >=
              scrollController.position.maxScrollExtent &&
          !isFetchMoreLoading.value &&
          hasMore.value) {
        print("FetchMore 실행 합니다!");

        Future.microtask(() => fetchMoreSimpleBreadsInfo());
      }
    });

    await fetchBakeryFilter();
    await fetchSearchedSimpleBreadInfo();
    // fetchFilterdBakeries();
    firstInitLoading(false);

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

  Future<void> _applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    await fetchSearchedSimpleBreadInfo();
  }

  get applyFilterChanged => _applyFilterChanged();

  void _initFilterSelected() {
    tempFilterIdList.clear();
    tempFilterIdList.add('1');
  }

  get initFilterSelected => _initFilterSelected();

  Future<void> _refreshBakeryInfoData() async {
    hasMore(true);
    await fetchSearchedSimpleBreadInfo();
  }

  Future<void> get refreshBakeryInfoData => _refreshBakeryInfoData();
  Future<void> fetchSearchedSimpleBreadInfo() async {
    return Future(() async {
      try {
        // print('largeCategoryId: $largeCategoryId');
        isLoading(true);
        final result = await FindPageApi.fetchSearchedSimpleBreadsInfo(
          searchTerm: SearchScreenController.to.termTextController.value.text,
          sortFilterId: sortFilterId.value,
          filterIdList: filterIdList,
        );
        print("FetchSimpleBreadInfo Result");
        print(result);
        if (result != null) {
          print("크롸!");
          List<dynamic> searchedSimpleBreadsInfoData =
              result.data['searchBreads'];
          simpleBreadListResult.clear();
          print(searchedSimpleBreadsInfoData);
          if (searchedSimpleBreadsInfoData.length > 0) {
            searchedSimpleBreadsInfoData.forEach((breadInfoJson) {
              simpleBreadListResult
                  .add(new BreadSimpleInfo.fromJson(breadInfoJson));
            });

            print(simpleBreadListResult);
            cursorBreadId(searchedSimpleBreadsInfoData[
                searchedSimpleBreadsInfoData.length - 1]['id']);
          }

          if (searchedSimpleBreadsInfoData.length == 0 ||
              searchedSimpleBreadsInfoData.length < SimpleBreadFetchMinimum) {
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
      isFetchMoreLoading(true);
      print('cursorBreadId: ${cursorBreadId.value}');
      final result = await FindPageApi.fetchSearchedSimpleBreadsInfo(
        searchTerm: SearchScreenController.to.termTextController.value.text,
        sortFilterId: sortFilterId.value,
        filterIdList: filterIdList,
        cursorBreadId: cursorBreadId.value,
        fetchMore: true,
      );
      if (result != null) {
        print(result);
        final List<dynamic> _newSimpleBreadsInfoResult =
            result.data['searchBreads'];
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

          cursorBreadId(_newSimpleBreadsInfoResult[
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
      isFetchMoreLoading(false);
    }
  }
}
