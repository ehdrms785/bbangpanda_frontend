import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:get/state_manager.dart';

Future<RxList<dynamic>?> fetchBakeryFilter() async {
  try {
    final result = await FindPageApi.fetchBakeryFilter();
    if (result != null) {
      print("여기들어왔어요");
      print(result);
      return (result.data['getBakeryFilter'] as List<Object?>).obs;
    }
  } catch (err) {
    print("에러발생용");
    print(err);
    return null;
  }
}

Future<void> fetchSimpleBakeriesInfo(
    {required RxBool isLoading,
    required RxBool hasMore,
    required RxString sortFilterId,
    required RxList<String> filterIdList,
    required List<dynamic> simpleBakeriesListResult,
    required RxInt cursorBakeryId}) async {
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
