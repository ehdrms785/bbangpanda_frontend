import 'package:bbangnarae_frontend/screens/FindBread/support/findBakeryApi.dart';
import 'package:get/get.dart';

// GetX OBX 이용한 예제

class BakeryFilterController extends GetxController {
  var isLoading = true.obs;
  var hasMore = true.obs;
  // late RxList<Map<String, dynamic>?> bakeriesResult;
  // var bakeriesResult;

  late RxList<dynamic> bakeriesResult = [].obs;
  late RxList<bool> filterSelected;
  var userResult = Map<String, dynamic>().obs;
  RxInt cursorId = 0.obs;
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
      isLoading(true);
      final result = await FindBakeryApi.fetchFilteredBakeries(
          filterIdList: ['1', '3', '4']);
      if (result != null) {
        // print(result);

        bakeriesResult =
            (result.data['getFilteredBakeryList'] as List<Object?>).obs;
        cursorId(bakeriesResult[bakeriesResult.length - 1]!['id']);
        print(bakeriesResult);
        print(bakeriesResult.runtimeType);
        filterSelected = List.generate(bakeriesResult.length, (index) {
          if (index == 0)
            return true;
          else
            return false;
        }).obs;
        print('BakeryFilter 확인하기');
        print(filterSelected);
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
      isLoading(true);
      print('cursorId: ${cursorId.value}');
      final result = await FindBakeryApi.fetchFilteredBakeries(
          filterIdList: ['1', '2'], cursorId: cursorId.value, fetchMore: true);
      if (result != null) {
        print(result);
        if (result.data['getFilteredBakeryList'] == null) {
          hasMore(false);
          return;
        }

        final List<dynamic> _newBakeriesResult =
            result.data['getFilteredBakeryList'];
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
      isLoading(false);
    }
  }
}
