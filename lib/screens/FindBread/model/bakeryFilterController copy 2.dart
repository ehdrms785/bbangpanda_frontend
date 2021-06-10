import 'package:bbangnarae_frontend/screens/FindBread/support/findPageApi.dart';
import 'package:get/get.dart';

class BakeryFilterController extends GetxController {
  var isLoading = true.obs;
  var hasMore = true.obs;
  var filterLoading = true.obs;
  // late RxList<Map<String, dynamic>?> bakeriesResult;
  // var bakeriesResult;
  late RxList<dynamic> bakeriesResult = [].obs;
  late RxList<dynamic> bakeryFilterResult = [].obs;
  var userResult = Map<String, dynamic>().obs;
  RxInt cursorId = 0.obs;
  final int FetchMinimum = 2;
  @override
  void onInit() {
    // TODO: implement onInit
    fetchFilterdBakeries();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void fetchFilterdBakeries() async {
    try {
      final result =
          await FindBakeryApi.fetchFilteredBakeries(filterIdList: ['1', '2']);
      if (result != null) {
        print(result.data);
        bakeriesResult =
            (result.data?['getFilteredBakeryList'] as List<Object?>).obs;
        cursorId(bakeriesResult[bakeriesResult.length - 1]!['id']);
        print(bakeriesResult);
        print(bakeriesResult.runtimeType);

        print(bakeriesResult.length);
      }
    } catch (err) {
      print("에러발새생");
      print(err);
    } finally {
      update();
      isLoading(false);
    }
  }

  void fetchMoreFilterBakeries() async {
    try {
      print('cursorId: ${cursorId.value}');
      final result = await FindBakeryApi.fetchFilteredBakeries(
          filterIdList: ['1', '2'], cursorId: cursorId.value, fetchMore: true);
      if (result != null) {
        print(result);
        final _newBakeriesResult = result.data['getFilteredBakeryList'];
        // 2개가 한 번에 가져오는 데이터 양이다. (나중에 바뀔 것임)
        //
        if (_newBakeriesResult == null) {
          hasMore(false);
          return;
        }
        // 최소로 가져올 수 있는 데이터보다 양이 적다는건 더 이상 가져올 데이터가 없다는 뜻!
        // 한 번더 Rendering을 하지 않기 위해 만든 로직
        if (_newBakeriesResult.length < FetchMinimum) hasMore(false);
        print('테스트테스트');
        print(_newBakeriesResult);

        bakeriesResult([...bakeriesResult, ..._newBakeriesResult]);

        cursorId(_newBakeriesResult[_newBakeriesResult.length - 1]!['id']);

        print("체크 cursirId: ${cursorId.value}");
      }
    } catch (err) {
      print("에러발새생");
      print(err);
    } finally {}
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
    }
  }
}
