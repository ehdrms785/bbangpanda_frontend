import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenController.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SearchBakeriesController extends GetxController implements BakeryModel {
  var firstInitLoading = true.obs;
  var isLoading = true.obs;
  var filterLoading = true.obs;
  var hasMore = true.obs;
  var isFetchMoreLoading = false;

  late RxList<dynamic> bakeryFilterResult = [].obs;
  RxInt cursorBakeryId = 0.obs;
  RxString sortFilterId = '1'.obs; // 최신순
  var filterIdList = ['1'].obs;
  RxList<String> tempFilterIdList = ['1'].obs;

  late ScrollController scrollController;

  late RxList<String> breadOptionFilterIdList;

  var simpleBakeriesListResult = <BakerySimpleInfo>[].obs;

  @override
  void onInit() async {
    print("ShowBreadsController onInit!");

    scrollController = new ScrollController();
    scrollController.addListener(() {
      print("Scroll 움직인다");

      if (scrollController.position.pixels + 400 >=
              scrollController.position.maxScrollExtent &&
          !isFetchMoreLoading &&
          hasMore.value) {
        print("FetchMore 실행 합니다!");

        Future.microtask(() => fetchMoreSimpleBakeriesInfo());
      }
    });

    await fetchBakeryFilter();
    await fetchSearchedSimpleBakeriesInfo();
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

  Future<void> _refreshBakeryInfoData() async {
    hasMore(true);
    await fetchSearchedSimpleBakeriesInfo();
  }

  Future<void> get refreshBakeryInfoData => _refreshBakeryInfoData();
  Future<void> fetchBakeryFilter() async {
    try {
      final result = await FindPageApi.fetchBakeryFilter();
      if (result != null) {
        print("여기들어왔어요");
        print(result);
        bakeryFilterResult =
            (result.data['getBakeryFilter'] as List<Object?>).obs;

        print(bakeryFilterResult);
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
    await fetchSearchedSimpleBakeriesInfo();
  }

  Future<void> get applyFilterChanged => _applyFilterChanged();
  void _initFilterSelected() {
    tempFilterIdList.clear();
    tempFilterIdList.add('1');
  }

  void get initFilterSelected => _initFilterSelected();
  Future<void> fetchSearchedSimpleBakeriesInfo() async {
    return Future(() async {
      try {
        // print('largeCategoryId: $largeCategoryId');
        isLoading(true);
        final result = await FindPageApi.fetchSearchedSimpleBakeriesInfo(
          searchTerm: SearchScreenController.to.termTextController.value.text,
          sortFilterId: sortFilterId.value,
          filterIdList: filterIdList,
        );
        print("FetchSearchedSimpleBreadInfo Result");
        print(result);
        if (result != null) {
          print("크롸!");
          List<dynamic> searchedSimpleBakeriesInfoData =
              result.data['searchBakeries'];
          simpleBakeriesListResult.clear();
          print(searchedSimpleBakeriesInfoData);
          if (searchedSimpleBakeriesInfoData.length > 0) {
            searchedSimpleBakeriesInfoData.forEach((breadInfoJson) {
              simpleBakeriesListResult
                  .add(new BakerySimpleInfo.fromJson(breadInfoJson));
            });

            print(simpleBakeriesListResult);
            cursorBakeryId(searchedSimpleBakeriesInfoData[
                searchedSimpleBakeriesInfoData.length - 1]['id']);
          }

          if (searchedSimpleBakeriesInfoData.length == 0 ||
              searchedSimpleBakeriesInfoData.length < SimpleBreadFetchMinimum) {
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

  void fetchMoreSimpleBakeriesInfo() async {
    try {
      print("fetchMoreSimpleBakeriesInfo ~들어왔다");
      // isFetchMoreLoading(true);
      isFetchMoreLoading = true;
      print('cursorBakeryId: ${cursorBakeryId.value}');
      final result = await FindPageApi.fetchSearchedSimpleBakeriesInfo(
        searchTerm: SearchScreenController.to.termTextController.value.text,
        sortFilterId: sortFilterId.value,
        filterIdList: filterIdList,
        cursorBakeryId: cursorBakeryId.value,
        fetchMore: true,
      );
      if (result != null) {
        print(result);
        final List<dynamic> _newSimpleBreadsInfoResult =
            result.data['searchBakeries'];
        // 2개가 한 번에 가져오는 데이터 양이다. (나중에 바뀔 것임)
        // 최소로 가져올 수 있는 데이터보다 양이 적다는건 더 이상 가져올 데이터가 없다는 뜻!
        // 한 번더 Rendering을 하지 않기 위해 만든 로직

        print("\n\n FetchMore SimpleBreads 데이터 보기 \n\n");

        print(_newSimpleBreadsInfoResult);
        if (_newSimpleBreadsInfoResult.length > 0) {
          _newSimpleBreadsInfoResult.forEach((breadInfoJson) {
            simpleBakeriesListResult
                .add(new BakerySimpleInfo.fromJson(breadInfoJson));
          });

          cursorBakeryId(_newSimpleBreadsInfoResult[
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
