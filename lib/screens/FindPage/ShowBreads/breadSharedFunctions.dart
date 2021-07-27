import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:get/state_manager.dart';

Future<RxList<dynamic>?> fetchBreadFilter(
    {required RxBool filterLoading}) async {
  try {
    final result = await FindPageApi.fetchBreadFilter();
    if (result != null) {
      print("여기들어왔어요");
      print(result);
      return (result.data['getBreadFilter'] as List<Object?>).obs;
    }
  } catch (err) {
    print("에러발생용");
    print(err);
    return null;
  } finally {
    filterLoading(false);
    // update(['filterBar']);
    // update(['bakeryFilerModal']);
    // print("2. FetchBakeryFilter 끝");
  }
}

Future<void> fetchSimpleBreadsInfo({
  int? bakeryId,
  required RxBool isLoading,
  required RxBool hasMore,
  required RxString sortFilterId,
  required RxList<dynamic> filterIdList,
  required String breadLargeCategoryId,
  required String? breadSmallCategoryId,
  required List<dynamic> simpleBreadListResult,
  required RxInt cursorBreadId,
}) async {
  return Future(() async {
    try {
      // print('largeCategoryId: $largeCategoryId');
      isLoading(true);
      final result = await FindPageApi.fetchSimpleBreadsInfo(
          bakeryId: bakeryId,
          sortFilterId: sortFilterId.value,
          filterIdList: filterIdList,
          largeCategoryId: breadLargeCategoryId,
          smallCategoryId: breadSmallCategoryId);
      print("FetchSimpleBreadInfo Result");
      print(result);
      if (result != null) {
        print("크롸!");
        List<dynamic> getSimpleBreadsInfoData =
            result.data['getSimpleBreadsInfo'];
        simpleBreadListResult.clear();

        if (getSimpleBreadsInfoData.length > 0) {
          getSimpleBreadsInfoData.forEach((breadInfoJson) {
            simpleBreadListResult
                .add(new BreadSimpleInfo.fromJson(breadInfoJson));
          });

          print(simpleBreadListResult);
          cursorBreadId(
              getSimpleBreadsInfoData[getSimpleBreadsInfoData.length - 1]
                  ['id']);
        }

        if (getSimpleBreadsInfoData.length == 0 ||
            getSimpleBreadsInfoData.length < SimpleBreadFetchMinimum) {
          print("SimpleBreads Fetch 한 데이터가 Minimum 이하라 hasMore : false");
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

void fetchMoreSimpleBreadsInfo({
  required RxBool hasMore,
  required RxBool isFetchMoreLoading,
  required RxString sortFilterId,
  required RxList<dynamic> filterIdList,
  required String breadLargeCategoryId,
  required String? breadSmallCategoryId,
  required List<dynamic> simpleBreadListResult,
  required RxInt cursorBreadId,
}) async {
  try {
    print("fetchMoreSimpleBreadsInfo ~들어왔다");
    // isFetchMoreLoading(true);
    isFetchMoreLoading(true);
    print('cursorBreadId: ${cursorBreadId.value}');
    final result = await FindPageApi.fetchSimpleBreadsInfo(
        filterIdList: filterIdList,
        sortFilterId: sortFilterId.value,
        cursorBreadId: cursorBreadId.value,
        largeCategoryId: breadLargeCategoryId,
        smallCategoryId: breadSmallCategoryId,
        fetchMore: true);
    if (result != null) {
      print(result);
      final List<dynamic> _newSimpleBreadsInfoResult =
          result.data['getSimpleBreadsInfo'];
      // 2개가 한 번에 가져오는 데이터 양이다. (나중에 바뀔 것임)
      // 최소로 가져올 수 있는 데이터보다 양이 적다는건 더 이상 가져올 데이터가 없다는 뜻!
      // 한 번더 Rendering을 하지 않기 위해 만든 로직

      print("\n\n FetchMore SimpleBreads 데이터 보기 \n\n");

      print(_newSimpleBreadsInfoResult);
      if (_newSimpleBreadsInfoResult.length > 0) {
        _newSimpleBreadsInfoResult.forEach((breadInfoJson) {
          simpleBreadListResult
              .add(new BreadSimpleInfo.fromJson(breadInfoJson));
        });

        cursorBreadId(_newSimpleBreadsInfoResult[
            _newSimpleBreadsInfoResult.length - 1]!['id']);
      }
      if (_newSimpleBreadsInfoResult.length < SimpleBreadFetchMinimum) {
        print("FetchMore 할 SimpleBreads 데이터가 없거나 적어서 hasMore: false 합니다");
        hasMore(false);
      }
    }
  } catch (err) {
    print("에러발새생1");
    print(err);
  } finally {
    isFetchMoreLoading(false);
  }
}
