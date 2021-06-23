import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowBreadsController extends GetxController
    with SingleGetTickerProviderMixin {
  ShowBreadsController({this.tabLength: 0});
  final int tabLength;
  late final TabController tabController;
  late final ScrollController scrollController;
  late RxList<dynamic> breadLargeCategories = [
    {'id': 0, 'category': '전체'},
    {'id': 1, 'category': '소프트브레드'},
    {'id': 2, 'category': '하드브레드'},
    {'id': 3, 'category': '디저트'},
  ].obs;

  var isShowAppBar = true.obs;
  var isLoading = true.obs;
  var isFetchMoreLoading = false;
  var hasMore = true.obs;
  RxList<String> breadSortFilterIdList = ['1'].obs;
  late RxList<String> breadOptionFilterIdList;

  RxList<dynamic> filterWidget = [].obs;
  RxInt cursorId = 0.obs;
  final int FetchMinimum = 2;

  RxList<String> filterIdList = ['1'].obs; // 제일 기본은 택배가능만 체크 된 상태
  RxList<String> tempFilterIdList = ['1'].obs;
  var simpleBreadListResult = <BreadSimpleInfo>[].obs;

  @override
  void onInit() async {
    tabController = TabController(length: tabLength, vsync: this);
    scrollController = ScrollController();
    print("1.FetchFilteredBreads 시작");
    // fetchFilterdBakeries();
    Future.delayed(Duration(seconds: 3), () => isLoading(false));
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void initFilterSelected() {
    tempFilterIdList.clear();
    tempFilterIdList.add('1');
  }

  void applyFilterChanged() async {
    filterIdList.clear();
    filterIdList.addAll(tempFilterIdList);
    hasMore(true);
    update(['filterBar']);
  }

  void fetchMoreFilterBreads() async {
    try {
      print("FetchMore ~들어왔다");
      // isFetchMoreLoading(true);
      isFetchMoreLoading = true;
      print('cursorId: ${cursorId.value}');
      final result = await FindPageApi.fetchFilteredBakeries(
          filterIdList: filterIdList,
          cursorId: cursorId.value,
          fetchMore: true);
      if (result != null) {
        // print(result);
        final _newBakeriesResult = result.data['getFilteredBakeryList'];
        // 2개가 한 번에 가져오는 데이터 양이다. (나중에 바뀔 것임)
        // 최소로 가져올 수 있는 데이터보다 양이 적다는건 더 이상 가져올 데이터가 없다는 뜻!
        // 한 번더 Rendering을 하지 않기 위해 만든 로직
        if (_newBakeriesResult == null ||
            _newBakeriesResult.length < FetchMinimum) {
          print("FetchMore 한 데이터가 없거나 적어서 hasMore: false 합니다");
          hasMore(false);
          update(['bakeryList']);
          return;
        }
        print("\n\n FetchMore 데이터 보기 \n\n");
        print(_newBakeriesResult);
      }
    } catch (err) {
      print("에러발새생1");
      print(err);
    } finally {
      // 수정했는데 괜찮겠지?
      // isFetchMoreLoading(false);
      // update(['bakeryFilerModal']);
      isFetchMoreLoading = false;
    }
  }
}
