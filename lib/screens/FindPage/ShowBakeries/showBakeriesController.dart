import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/findpageScreenController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPagetypeDef.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

/*
FilterIdList
-택배 && 매장 관련
  1: 택배가능
  2: 매장취식
  
  
- 빵옵션 관련
  3: 우리밀
  4: 유기농밀
  5: 글루텐프리
  6: 무가당
  7: 천연발효
*/

class ShowBakeriesController extends GetxController implements BakeryModel {
  var firstInitLoading = true.obs;
  var isLoading = true.obs;
  var filterLoading = true.obs;
  var hasMore = true.obs;
  var isFetchMoreLoading = false;

  final RxBool isShowAppBar = FindPageScreenController.to.isShowAppBar;
  late RxList<dynamic> bakeryFilterResult = [].obs;
  RxInt cursorBakeryId = 0.obs;
  RxString sortFilterId = '1'.obs; // 최신순
  RxList<String> filterIdList = ['1'].obs; // 제일 기본은 택배가능만 체크 된 상태
  RxList<String> tempFilterIdList = ['1'].obs;

  late final ScrollController scrollController;

  var simpleBakeriesListResult = <BakerySimpleInfo>[].obs;

  @override
  void onInit() async {
    print("ShowBakeriesController onInit!");
    // fetchSimpleBakeriesInfo();
    scrollController = ScrollController();
    scrollController.addListener(() {
      print("Scroll 움직인다");
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        isShowAppBar(true);
      } else {
        isShowAppBar(false);

        if (scrollController.position.pixels + 500 >=
                scrollController.position.maxScrollExtent &&
            !isFetchMoreLoading &&
            hasMore.value) {
          print("FetchMore 실행 !");

          Future.microtask(() => fetchMoreSimpleBakeriesInfo());
        }
      }
    });
    await fetchBakeryFilter();
    await fetchSimpleBakeriesInfo();
    firstInitLoading(false);
    super.onInit();
  }

  @override
  void onClose() {
    print("ShowBakeriesController Dispose!");
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _refreshBakeryInfoData() async {
    hasMore(true);
    await fetchSimpleBakeriesInfo();
  }

  // Future<void> refreshMarketOrderInfoData () {

  // }

  Future<void> get refreshBakeryInfoData => _refreshBakeryInfoData();
  void _initFilterSelected() async {
    tempFilterIdList.clear();
    tempFilterIdList.add('1');
  }

  @override
  get initFilterSelected => _initFilterSelected();

  void _applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    await fetchSimpleBakeriesInfo();
  }

  @override
  get applyFilterChanged => _applyFilterChanged();

  Future<void> fetchSimpleBakeriesInfo() async {
    return Future(() async {
      try {
        isLoading(true);

        final result = await FindPageApi.fetchSimpleBakeriesInfo(
            sortFilterId: sortFilterId.value, filterIdList: filterIdList);
        print("Result 확인");
        print(result);
        if (result != null) {
          print("이곳을확인");
          // print(result);
          List<dynamic> getSimpleBakeriesInfoData =
              result.data?['getSimpleBakeriesInfo'];
          print(getSimpleBakeriesInfoData);
          simpleBakeriesListResult.clear();
          print("야호");
          if (getSimpleBakeriesInfoData.length > 0) {
            getSimpleBakeriesInfoData.forEach((bakeryInfoJson) {
              print("하이");
              print(bakeryInfoJson);
              simpleBakeriesListResult
                  .add(new BakerySimpleInfo.fromJson(bakeryInfoJson));
            });
            cursorBakeryId(getSimpleBakeriesInfoData[
                getSimpleBakeriesInfoData.length - 1]!['id']);
          }

          if (getSimpleBakeriesInfoData.length == 0 ||
              getSimpleBakeriesInfoData.length < SimpleBakeryFetchMinimum) {
            print("Fetch 한 데이터가 없거나 적어서 hasMore: false 합니다");
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
      isFetchMoreLoading = true;
      print('cursorBakeryId: ${cursorBakeryId.value}');
      final result = await FindPageApi.fetchSimpleBakeriesInfo(
          sortFilterId: sortFilterId.value,
          filterIdList: filterIdList,
          cursorBakeryId: cursorBakeryId.value,
          fetchMore: true);
      if (result != null) {
        // print(result);
        final List<dynamic> _newSimpleBakeriesResult =
            result.data['getSimpleBakeriesInfo'];
        // 2개가 한 번에 가져오는 데이터 양이다. (나중에 바뀔 것임)
        // 최소로 가져올 수 있는 데이터보다 양이 적다는건 더 이상 가져올 데이터가 없다는 뜻!
        // 한 번더 Rendering을 하지 않기 위해 만든 로직

        print("\n\n FetchMore 데이터 보기 \n\n");
        print(_newSimpleBakeriesResult);
        if (_newSimpleBakeriesResult.length > 0) {
          _newSimpleBakeriesResult.forEach((bakeryInfoJson) {
            simpleBakeriesListResult
                .add(new BakerySimpleInfo.fromJson(bakeryInfoJson));
          });
          cursorBakeryId(_newSimpleBakeriesResult[
              _newSimpleBakeriesResult.length - 1]!['id']);
        }
        if (_newSimpleBakeriesResult.length < SimpleBakeryFetchMinimum) {
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

  // @override
  // Function initFilterSelected = () {};

}
