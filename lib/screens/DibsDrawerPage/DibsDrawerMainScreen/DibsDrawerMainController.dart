import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerPageApi.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerPageQuery.dart';
import 'package:bbangnarae_frontend/screens/DibsDrawerPage/dibsDrawerModel.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedClass.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

List<DibsDrawerInfo> testDibsDrawerList = [
  DibsDrawerInfo.fromJson(
    {
      'id': 1,
      'name': '테스트서랍1',
      'item': [
        {
          'id': 1,
          'name': '테스트1번빵',
          'thumbnail': 'assets/breadImage.jpg',
          'price': 5000,
          'discount': 10,
          'description': '테스트1번빵의 상세설명입니다'
        },
        {
          'id': 2,
          'name': '테스트2번빵',
          'thumbnail': 'assets/다로크림빵.png',
          'price': 4000,
          'discount': 0,
          'description': '테스트2번빵의 상세설명입니다'
        },
      ],
      'itemCount': 2
    },
  ),
  DibsDrawerInfo.fromJson(
    {
      'id': 2,
      'name': '테스트서랍2',
      'item': [
        {
          'id': 3,
          'name': '테스트3번빵',
          'thumbnail': 'assets/아나식빵.jpg',
          'price': 5000,
          'discount': 10,
          'description': '테스트3번빵의 상세설명입니다'
        },
        {
          'id': 4,
          'name': '테스트4번빵',
          'thumbnail': 'assets/다로크림빵.png',
          'price': 4000,
          'discount': 0,
          'description': '테스트4번빵의 상세설명입니다'
        },
        {
          'id': 5,
          'name': '테스트5번빵',
          'thumbnail': 'assets/다로팥빵.jpg',
          'price': 4000,
          'discount': 0,
          'description': '테스트5번빵의 상세설명입니다'
        },
        {
          'id': 6,
          'name': '테스트6번빵',
          'thumbnail': 'assets/100%호밀빵.jpg',
          'price': 4000,
          'discount': 0,
          'description': '테스트6번빵의 상세설명입니다'
        },
      ],
      'itemCount': 4
    },
  ),
];

class DibsDrawerMainController extends GetxController {
  late final ScrollController scrollController;
  late final TextEditingController drawerNameTextController;

  RxBool drawerNameisEmpty = true.obs;
  RxBool isLoading = true.obs;
  RxBool firstInitLoading = true.obs;
  bool someDibsDrawerChanged = false;
  static DibsDrawerMainController get to => Get.find();

  // RxList<DibsDrawerInfo>? dibsDrawerList;
  RxList<DibsDrawerInfo?>? dibsDrawerList = [null].obs;

  @override
  void onInit() async {
    scrollController = new ScrollController();
    drawerNameTextController = new TextEditingController();
    await _fetchDibsDrawerList();
    Future.delayed(Duration(seconds: 1), () => firstInitLoading(false));
    super.onInit();
  }

  Future<void> fetchDibsDrawerList() async {
    await _fetchDibsDrawerList();
  }

  Future<void> _fetchDibsDrawerList() async {
    return Future(() async {
      try {
        isLoading(true);
        final result = await DibsDrawerPageApi.fetchDibsDrawerListApi(count: 4);
        if (result != null) {
          print(result);
          final getDibsDrawerListResult = result.data?['getDibsDrawerList'];
          print("getDibsDrawerListResult 결과값 확인하기");
          print(getDibsDrawerListResult);
          if (getDibsDrawerListResult == null) return;
          // print('getDibsCount: ${getDibsDrawerListResult.length}');
          dibsDrawerList = (getDibsDrawerListResult
                  .map<DibsDrawerInfo>(
                      (dibsDrawer) => DibsDrawerInfo.fromJson(dibsDrawer))
                  .toList() as List<DibsDrawerInfo>)
              .obs;

          // print(test.runtimeType);
          // dibsDrawerList = test.obs as RxList<DibsDrawerInfo>;
          print(dibsDrawerList);
        }
      } catch (err) {
        print("fetchDibsDrawerList 에러");
        print(err);
      } finally {
        isLoading(false);
      }
    });
  }

  void createDrawer({required String name}) async {
    try {
      final result = await DibsDrawerPageApi.createDibsDrawerApi(name: name);
      var QueryRequest = Request(
          operation: Operation(
        document: gql(DibsDrawerPageQuery.getDibsDrawerListQuery(count: 4)),
      ));
      // print(QueryRequest);
      var readCache = client.cache.readQuery(QueryRequest);
      print(readCache);
      print(result!.data!['createDibsDrawer']);
      print(result!.data!['createDibsDrawer']['dibsDrawer']);
      dibsDrawerList!.add(DibsDrawerInfo.fromJson(
          result!.data!['createDibsDrawer']['dibsDrawer']));
    } catch (err) {
      print("CreateDrawer Error");
      print(err);
    }
  }

  void deleteDrawer({required int id}) async {
    try {
      final result = await DibsDrawerPageApi.deleteDibsDrawerApi(id: id);
      print(result);
      final deleteDrawerResult = result!.data['deleteDibsDrawer'];
      if (deleteDrawerResult != null) {
        print(deleteDrawerResult);
        if (deleteDrawerResult['ok']) {
          dibsDrawerList!.removeWhere((element) => element!.id == id);
          return;
        } else {
          makeErrorBoxAndShow(error: deleteDrawerResult['error']);
        }
      }
    } catch (err) {
      print("DeleteDrawer Error");
      print(err);
    } finally {
      Get.back();
    }
  }

  void changeDibsDrawer({required int id, required String name}) async {
    try {
      final result =
          await DibsDrawerPageApi.changeDibsDrawerNameApi(id: id, name: name);
      print(result);
      final changeDibsDrawerNameResult = result!.data['changeDibsDrawerName'];
      if (changeDibsDrawerNameResult != null) {
        print(changeDibsDrawerNameResult);
        if (changeDibsDrawerNameResult['ok']) {
          dibsDrawerList!.singleWhere((element) => element!.id == id)!.name =
              name;

          dibsDrawerList!.refresh();

          return;
        } else {
          makeErrorBoxAndShow(error: changeDibsDrawerNameResult['error']);
        }
      }
    } catch (err) {
      print("ChagneDibsDrawerName Error");
      print(err);
    } finally {
      Get.back();
    }
  }

  Future<bool> toggleItemToDibsDrawer(
      {required bool isGotDibs,
      int? drawerId,
      required int itemId,
      required String breadName,
      String? drawerName}) async {
    return Future(() async {
      try {
        if (isGotDibs == true) {
          final result =
              await DibsDrawerPageApi.removeItemToDrawerApi(itemId: itemId);
          print("RemoveItemToDibsDrawer 결과");
          print(result);
          final removeItemToDibsDrawerResult =
              result.data['removeItemToDibsDrawer'];
          if (removeItemToDibsDrawerResult != null) {
            if (removeItemToDibsDrawerResult['ok']) {
              showSnackBar(message: '$breadName이 성공적으로 제거 되었습니다');
              return true;
            } else {
              makeErrorBoxAndShow(error: removeItemToDibsDrawerResult['error']);
              return false;
            }
          }
        } else {
          Get.back();
          final result = await DibsDrawerPageApi.addItemToDrawerApi(
              drawerId: drawerId!, itemId: itemId);
          print("AddItemToDibsDrawer 결과");
          print(result);
          final addItemToDibsDrawerResult = result.data['addItemToDibsDrawer'];
          if (addItemToDibsDrawerResult != null) {
            if (addItemToDibsDrawerResult['ok']) {
              showSnackBar(message: '$breadName이 $drawerName에 추가되었습니다');
              return true;
            } else {
              makeErrorBoxAndShow(error: addItemToDibsDrawerResult['error']);
              return false;
            }
          }
        }
      } catch (err) {
        print("AddItemToDibsDrawer Error");
        print(err);
        return false;
      } finally {}
      return false;
    });
  }
}
