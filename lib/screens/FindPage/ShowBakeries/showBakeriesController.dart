import 'package:bbangnarae_frontend/screens/FindBread/support/findPageApi.dart';
import 'package:flutter/material.dart';
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
class ShowBakeriesController extends GetxController {
  var isLoading = true.obs;
  var isFetchMoreLoading = false;
  var hasMore = true.obs;
  var filterLoading = true.obs;

  late RxList<dynamic> bakeriesResult = [].obs;
  late RxList<dynamic> bakeryFilterResult = [].obs;
  RxList<dynamic> filterWidget = [].obs;
  RxInt cursorId = 0.obs;
  final int FetchMinimum = 2;
  RxList<String> filterIdList = ['1'].obs; // 제일 기본은 택배가능만 체크 된 상태
  RxList<String> tempFilterIdList = ['1'].obs;

  @override
  void onInit() async {
    print("\n\n 1. FetchBakeryFilter 순서 체크 로직 \n\n");
    fetchBakeryFilter();
    print("3. FetchFilterBakeries 시작");
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
        print("이곳을확인");
        // print(result.data);
        bakeriesResult =
            (result.data?['getFilteredBakeryList'] as List<Object?>).obs;
        print(result.data!['getBakeryFilter']);
        if (bakeriesResult.length == 0 ||
            bakeriesResult.length < FetchMinimum) {
          print("Fetch 한 데이터가 없거나 적어서 hasMore: false 합니다");
          hasMore(false);
          update(['bakeryList']);
          return;
        }
        cursorId(bakeriesResult[bakeriesResult.length - 1]!['id']);
        // print(bakeriesResult);

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

        bakeriesResult([...bakeriesResult, ..._newBakeriesResult]);
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

  void fetchBakeryFilter() async {
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
