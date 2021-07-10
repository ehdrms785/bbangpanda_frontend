import 'package:bbangnarae_frontend/screens/FindPage/ShowMarketOrders/marketOrderModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/findpageScreenController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchMarketsScreen/searchMarketsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ShowMarketOrdersController extends GetxController
    implements MarketOrderModel {
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

  RxBool isShowAppBar = FindPageScreenController.to.isShowAppBar;

  @override
  RxList marketOrderFilterResult = [].obs;

  @override
  late ScrollController scrollController;

  @override
  var simpleMarketOrdersListResult = <MarketOrderSimpleInfo>[].obs;

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
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        isShowAppBar(true);
      } else {
        isShowAppBar(false);

        if (scrollController.position.pixels + 500 >=
                scrollController.position.maxScrollExtent &&
            !isFetchMoreLoading &&
            hasMore.value) {
          print("FetchMore 실행");
          Future.microtask(() => fetchMoreSimpleMarketOrdersInfo());
        }
      }
    });
    // TODO: implement onInit
    await fetchMarketOrderFilter();
    await fetchSimpleMarketOrdersInfo();
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

  get initFilterSelected => _initFilterSelected();

  Future<void> _refreshMarketOrderInfoData() async {
    hasMore(true);
    await fetchSimpleMarketOrdersInfo();
  }

  Future<void> get refreshMarketOrderInfoData => _refreshMarketOrderInfoData();

  Future<void> _applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    await fetchSimpleMarketOrdersInfo();
  }

  Future<void> get applyFilterChanged => _applyFilterChanged();

  Future<void> fetchSimpleMarketOrdersInfo() async {
    return Future(() async {
      try {
        isLoading(true);
        final result = await FindPageApi.fetchSimpleMarketOrdersInfo(
            filterIdList: filterIdList, sortFilterId: sortFilterId.value);
        if (result != null) {
          print("Result 확인");
          print(result);
          List<dynamic> getSimpleMarketOrdersInfoData =
              result.data?['getSimpleMarketOrdersInfo'];
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
      final result = await FindPageApi.fetchSimpleMarketOrdersInfo(
          sortFilterId: sortFilterId.value,
          filterIdList: filterIdList,
          cursorMarketOrderId: cursorMarketOrderId.value,
          fetchMore: true);
      if (result != null) {
        print(result);
        final List<dynamic> _newSimpleMarketOrdersResult =
            result.data['getSimpleMarketOrdersInfo'];
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
