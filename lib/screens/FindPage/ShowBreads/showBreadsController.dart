import 'package:bbangnarae_frontend/screens/FindBread/support/findPageApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowBreadsController extends GetxController {
  var isLoading = true.obs;
  var isFetchMoreLoading = false;
  var hasMore = true.obs;
  var filterLoading = true.obs;
  late RxList<dynamic> breadsResult = [].obs;
  late RxList<dynamic> bakeryFilterResult = [].obs;
  late RxList<dynamic> breadLargeCategories = [
    {'id': 0, 'category': '전체'},
    {'id': 1, 'category': '소프트브레드'},
    {'id': 2, 'category': '하드브레드'},
    {'id': 3, 'category': '디저트'},
  ].obs;
  RxList<dynamic> filterWidget = [].obs;
  RxInt cursorId = 0.obs;
  final int FetchMinimum = 2;
  RxList<String> filterIdList = ['1'].obs; // 제일 기본은 택배가능만 체크 된 상태
  RxList<String> tempFilterIdList = ['1'].obs;

  @override
  void onInit() async {
    print("1.FetchFilteredBreads 시작");
    fetchFilterdBakeries();
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
    fetchFilterdBakeries();
    update(['filterBar']);
  }

  void fetchFilterdBakeries() async {
    try {
      isLoading(true);
      final result =
          await FindPageApi.fetchFilteredBakeries(filterIdList: filterIdList);

      if (result != null) {
        print(result.data);
        breadsResult =
            (result.data?['getFilteredBakeryList'] as List<Object?>).obs;

        if (breadsResult.length == 0 || breadsResult.length < FetchMinimum) {
          print("Fetch 한 데이터가 없거나 적어서 hasMore: false 합니다");
          hasMore(false);
          update(['bakeryList']);
          return;
        }
        cursorId(breadsResult[breadsResult.length - 1]!['id']);
        // print(breadsResult);

      }
    } catch (err) {
      print("에러발새생");
      print(err);
    } finally {
      isLoading(false);
      print("4. FetchFilteredBakeries 끝");
    }
  }

  void fetchMoreFilterBakeries() async {
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

        breadsResult([...breadsResult, ..._newBakeriesResult]);
        cursorId(_newBakeriesResult[_newBakeriesResult.length - 1]!['id']);
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

  void fetchBreadFilter() async {
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
      update(['filterBar']);
      // update(['bakeryFilerModal']);
      print("2. FetchBakeryFilter 끝");
    }
  }
}
