import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:ui';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';

class BakeryDetailMainController extends GetxController
    with SingleGetTickerProviderMixin
    implements BakeryModel {
  // 애니메이션
  late AnimationController ColorAnimationController;
  late AnimationController TextAnimationController;
  late Animation colorTween, iconColorTween, appBarTextColorTween;
  late Animation<double> fadeTween;
  late Animation<Offset> transTween;
  var test = true.obs;
  late final ScrollController scrollController;
  var bakeryLikeBtnShow = false.obs;

  // BakeryModel
  var firstInitLoading = true.obs;
  var isLoading = true.obs;
  var filterLoading = true.obs;
  var hasMore = true.obs;
  var isFetchMoreLoading = false;

  late BakeryDetailInfo bakeryDetailInfo;
  late RxList<dynamic> bakeryFilterResult = [].obs;
  RxInt cursorBakeryId = 0.obs;
  RxString sortFilterId = '1'.obs; // 최신순
  RxList<String> filterIdList = ['1'].obs; // 제일 기본은
  RxList<String> tempFilterIdList = ['1'].obs;
  var simpleBakeriesListResult = <BakerySimpleInfo>[].obs;

  @override
  // TODO: implement applyFilterChanged
  get applyFilterChanged => throw UnimplementedError();

  @override
  // TODO: implement initFilterSelected
  get initFilterSelected => throw UnimplementedError();

  @override
  // TODO: implement refreshBakeryInfoData
  get refreshBakeryInfoData => throw UnimplementedError();

  @override
  void onInit() async {
    scrollController = new ScrollController();

    scrollController.addListener(() {
      print("Scroll 움직인다");

      if (scrollController.position.pixels + 500 >=
              scrollController.position.maxScrollExtent &&
          !isFetchMoreLoading &&
          hasMore.value) {
        print("FetchMore 실행 !");
        // Future.microtask(() => fetchMoreSimpleBakeriesInfo());
      }
    });

    ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(ColorAnimationController);
    iconColorTween = ColorTween(begin: Colors.white, end: Colors.grey)
        .animate(ColorAnimationController);

    appBarTextColorTween =
        ColorTween(begin: Colors.transparent, end: Colors.black)
            .animate(ColorAnimationController);
    TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    fadeTween = Tween(begin: 0.0, end: 1.0).animate(ColorAnimationController);
    transTween = Tween(begin: Offset(0, 30), end: Offset(0, 0))
        .animate(TextAnimationController);

    await fetchBakeryDetail();

    print("여기까지 왔을텐데");
    firstInitLoading(false);
    super.onInit();
  }

  @override
  void onClose() {
    ColorAnimationController.dispose();
    TextAnimationController.dispose();
    scrollController.dispose();
    // TODO: implement onClose
    super.onClose();
  }

  bool scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      var calcScrollEventAppearValue = scrollInfo.metrics.pixels / 20.0.h;
      ColorAnimationController.animateTo(calcScrollEventAppearValue);
      if (calcScrollEventAppearValue >= 1) {
        bakeryLikeBtnShow(true);
      } else {
        bakeryLikeBtnShow(false);
      }
    }
    return false;
  }

// Functions
// =======================
  Future<void> fetchBakeryDetail() async {
    return Future(() async {
      try {
        isLoading(true);
        print("Get에서 가져온 bakeryId : ${Get.arguments['bakeryId']}");
        final result = await FindPageApi.fetchBakeryDetail(
            bakeryId: Get.arguments['bakeryId']);
        // 가져온 데이터가 없으면 문제가 있는 것이니 에러페이지 보내기

        final bakeryDetailResult = result.data?['getBakeryDetail'];
        bakeryDetailInfo = BakeryDetailInfo.fromJson(
            bakeryDetailResult['bakery'], bakeryDetailResult['dibedUserCount']);
        print("GetBakeryDetail Result 보기");
        print(bakeryDetailInfo);
      } catch (err) {
        print("에러발생");
        print(err);
      } finally {
        isLoading(false);
      }
    });
  }
}
