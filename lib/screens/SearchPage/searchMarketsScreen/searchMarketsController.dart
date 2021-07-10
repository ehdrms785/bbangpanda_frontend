import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowMarketOrders/marketOrderModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowMarketOrders/showMarketOrdersController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenController.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

class SearchMarketOrderController extends GetxController
    implements MarketOrderModel {
  // var firstInitLoading = true.obs;
  // var isLoading = true.obs;
  // var filterLoading = true.obs;
  // var hasMore = true.obs;
  // var isFetchMoreLoading = false;

  // late RxList<dynamic> marketOrderFilterResult = [].obs;
  // RxInt cursorMarketOrderId = 0.obs;
  // RxString sortFilterId = '1'.obs; // 최신순
  // RxList<dynamic> filterIdList = [].obs; // 제일 기본은 택배가능만 체크 된 상태
  // RxList<dynamic> tempFilterIdList = [].obs;
  // @override
  // late ScrollController scrollController;

  // var simpleMarketOrdersListResult = <MarketOrderSimpleInfo>[].obs;

  @override
  var filterLoading = true.obs;

  @override
  var firstInitLoading = true.obs;

  @override
  var hasMore = true.obs;

  @override
  var isFetchMoreLoading = false;

  @override
  var isLoading = true.obs;

  @override
  RxList marketOrderFilterResult = [].obs;

  @override
  late ScrollController scrollController;

  @override
  var simpleMarketOrdersListResult = <MarketOrderSimpleInfo>[].obs;
  // var simpleMarketOrdersListResult = <MarketOrderSimpleInfo>[].obs;

  @override
  RxString sortFilterId = '1'.obs;

  @override
  RxList tempFilterIdList = [].obs;
  @override
  RxInt cursorMarketOrderId = 0.obs;

  @override
  RxList filterIdList = [].obs;

  @override
  void onInit() async {
    print("ShowMarketOrdersController onInit!");
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels + 500 >=
              scrollController.position.maxScrollExtent &&
          !isFetchMoreLoading &&
          hasMore.value) {
        print("FetchMore 실행");
        Future.microtask(() => fetchMoreSimpleMarketOrdersInfo());
      }
    });
    // TODO: implement onInit
    await fetchMarketOrderFilter();
    await fetchSearchedSimpleMarketOrdersInfo();
    firstInitLoading(false);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.onClose();
  }

  void _initFilterSelected() {
    tempFilterIdList.clear();
  }

  void get initFilterSelected => _initFilterSelected();
  Future<void> _refreshMarketOrderInfoData() async {
    hasMore(true);
    await fetchSearchedSimpleMarketOrdersInfo();
  }

  Future<void> get refreshMarketOrderInfoData => _refreshMarketOrderInfoData();

  Future<void> _applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    await fetchSearchedSimpleMarketOrdersInfo();
  }

  Future<void> get applyFilterChanged => _applyFilterChanged();
  Future<void> fetchSearchedSimpleMarketOrdersInfo() async {
    return Future(() async {
      try {
        isLoading(true);
        final result = await FindPageApi.fetchSearchedSimpleMarketOrdersInfo(
            searchTerm: SearchScreenController.to.termTextController.value.text,
            filterIdList: filterIdList,
            sortFilterId: sortFilterId.value);
        if (result != null) {
          print("Result 확인");
          print(result);
          List<dynamic> getSimpleMarketOrdersInfoData =
              result.data?['searchMarketOrders'];
          print(getSimpleMarketOrdersInfoData);
          simpleMarketOrdersListResult.clear();
          if (getSimpleMarketOrdersInfoData.length > 0) {
            getSimpleMarketOrdersInfoData.forEach((marketOrderInfoJson) {
              simpleMarketOrdersListResult
                  .add(new MarketOrderSimpleInfo.fromJson(marketOrderInfoJson));
            });
            cursorMarketOrderId(getSimpleMarketOrdersInfoData[
                getSimpleMarketOrdersInfoData.length - 1]!['id']);
          }

          if (getSimpleMarketOrdersInfoData.length == 0 ||
              getSimpleMarketOrdersInfoData.length <
                  SimpleMarketOrderFetchMinimum) {
            print("Fetch 한 데이터가 없거나 적어서 hasMore: false 합니다");
            hasMore(false);
          }
        }
      } catch (err) {
        print("에러확인");
        print(err);
      } finally {
        isLoading(false);
      }
    });
  }

  void fetchMoreSimpleMarketOrdersInfo() async {
    try {
      print("fetchMoreSimpleMarketOrdersInfo ~들어왔다");
      isFetchMoreLoading = true;
      print('cursorMarketOrderId: ${cursorMarketOrderId.value}');
      final result = await FindPageApi.fetchSearchedSimpleMarketOrdersInfo(
          searchTerm: SearchScreenController.to.termTextController.value.text,
          sortFilterId: sortFilterId.value,
          filterIdList: filterIdList,
          cursorMarketOrderId: cursorMarketOrderId.value,
          fetchMore: true);
      if (result != null) {
        print(result);
        final List<dynamic> _newSimpleMarketOrdersResult =
            result.data['searchMarketOrders'];
        // 2개가 한 번에 가져오는 데이터 양이다. (나중에 바뀔 것임)
        // 최소로 가져올 수 있는 데이터보다 양이 적다는건 더 이상 가져올 데이터가 없다는 뜻!
        // 한 번더 Rendering을 하지 않기 위해 만든 로직

        print("\n\n FetchMore 데이터 보기 \n\n");
        print(_newSimpleMarketOrdersResult);
        if (_newSimpleMarketOrdersResult.length > 0) {
          _newSimpleMarketOrdersResult.forEach((bakeryInfoJson) {
            simpleMarketOrdersListResult
                .add(new MarketOrderSimpleInfo.fromJson(bakeryInfoJson));
          });
          cursorMarketOrderId(_newSimpleMarketOrdersResult[
              _newSimpleMarketOrdersResult.length - 1]!['id']);
        }
        if (_newSimpleMarketOrdersResult.length <
            SimpleMarketOrderFetchMinimum) {
          print("FetchMore 한 데이터가 없거나 적어서 hasMore: false 합니다");
          hasMore(false);
          hasMore.update((val) {
            val = false;
          });
        }
      }
    } catch (err) {
      print("에러발새생1");
      print(err);
    } finally {
      isFetchMoreLoading = false;
    }
  }

  Future<void> fetchMarketOrderFilter() async {
    try {
      final result = await FindPageApi.fetchMarketOrderFilter();
      if (result != null) {
        print("여기들어왔어요");
        print(result);
        marketOrderFilterResult =
            (result.data['getMarketOrderFilter'] as List<Object?>).obs;

        print(marketOrderFilterResult);
      }
    } catch (err) {
      print("에러발생용");
      print(err);
    } finally {
      filterLoading(false);
    }
  }
}
