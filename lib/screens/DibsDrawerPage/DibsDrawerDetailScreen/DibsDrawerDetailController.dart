import 'package:bbangnarae_frontend/screens/DibsDrawerPage/DibsDrawerPageApi.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DibsDrawerDetailController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool hasMore = true.obs;

  late final ScrollController scrollController;
  RxList<DrawerItemInfo?>? dibsDrawerItemList = [null].obs;

  @override
  void onInit() async {
    scrollController = new ScrollController();
    await fetchDibsDrawerItems(drawerId: Get.arguments['drawerId']);

    isLoading(false);
    super.onInit();
  }

  Future<void> fetchDibsDrawerItems({
    required int drawerId,
    int? cursorBreadId,
  }) async {
    try {
      isLoading(true);
      final result = await DibsDrawerPageApi.fetchDibsDrawerItems(
          drawerId: drawerId, cursorBreadId: cursorBreadId);
      if (result == null) return null;
      final dibsDrawerItemsResult = result.data['fetchDibsDrawerItems'];
      print(dibsDrawerItemsResult);
      if (dibsDrawerItemsResult == null || dibsDrawerItemsResult.length == 0)
        return null;
      dibsDrawerItemsResult.forEach((drawerItemJson) {
        print(drawerItemJson);
      });
      print(dibsDrawerItemList);
    } catch (err) {
      print('FetchDibsDrawerItems Error 발생');
      print(err);
    } finally {
      isLoading(false);
    }
  }
}
