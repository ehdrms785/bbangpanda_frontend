import 'package:bbangnarae_frontend/screens/FindBread/support/findBakeryApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BakeryFilterController extends GetxController {
  var isLoading = true.obs;
  var isFetchMoreLoading = false.obs;
  var hasMore = true.obs;
  var filterLoading = true.obs;
  late RxList<dynamic> bakeriesResult = [].obs;
  late RxList<dynamic> bakeryFilterResult = [].obs;
  RxInt cursorId = 0.obs;
  final int FetchMinimum = 2;
  RxList<String> filterIdList = ['1'].obs; // 제일 기본은 택배가능만 체크 된 상태
  RxList<String> tempFilterIdList = ['1'].obs;

  @override
  void onInit() async {
    fetchBakeryFilter();
    fetchFilterdBakeries();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void initFilterSelected() {
    print("ㅇㅇ?");
    tempFilterIdList.clear();
    tempFilterIdList.add('1');
    print(tempFilterIdList);
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
          await FindBakeryApi.fetchFilteredBakeries(filterIdList: filterIdList);
      if (result != null) {
        print(result.data);
        bakeriesResult =
            (result.data?['getFilteredBakeryList'] as List<Object?>).obs;
        cursorId(bakeriesResult[bakeriesResult.length - 1]!['id']);
        // print(bakeriesResult);

      }
    } catch (err) {
      print("에러발새생");
      print(err);
    } finally {
      isLoading(false);
    }
  }

  void fetchMoreFilterBakeries() async {
    try {
      print("뺏치 모어 ~들어왔다");
      isFetchMoreLoading(true);
      print('cursorId: ${cursorId.value}');
      final result = await FindBakeryApi.fetchFilteredBakeries(
          filterIdList: filterIdList,
          cursorId: cursorId.value,
          fetchMore: true);
      if (result != null) {
        print(result);
        final _newBakeriesResult = result.data['getFilteredBakeryList'];
        // 2개가 한 번에 가져오는 데이터 양이다. (나중에 바뀔 것임)
        //
        if (_newBakeriesResult == null) {
          print("없습니다");
          hasMore(false);
          update(['bakeryList']);
          return;
        }
        // 최소로 가져올 수 있는 데이터보다 양이 적다는건 더 이상 가져올 데이터가 없다는 뜻!
        // 한 번더 Rendering을 하지 않기 위해 만든 로직
        if (_newBakeriesResult.length < FetchMinimum) {
          hasMore(false);
          update(['bakeryList']);
        }
        print('테스트테스트');
        print(_newBakeriesResult);

        bakeriesResult([...bakeriesResult, ..._newBakeriesResult]);

        cursorId(_newBakeriesResult[_newBakeriesResult.length - 1]!['id']);

        print("체크 cursirId: ${cursorId.value}");
      }
    } catch (err) {
      print("에러발새생");
      print(err);
    } finally {
      isFetchMoreLoading(false);
    }
  }

  void fetchBakeryFilter() async {
    try {
      final result = await FindBakeryApi.fetchBakeryFilter();
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
    }
  }
}
