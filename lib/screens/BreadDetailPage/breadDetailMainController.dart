import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadSharedFunctions.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPageApi.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BreadDetailMainController extends GetxController
    with SingleGetTickerProviderMixin {
  // 애니메이션
  late AnimationController ColorAnimationController;
  late AnimationController TextAnimationController;
  late Animation colorTween, iconColorTween, appBarTextColorTween;
  late Animation<double> fadeTween;
  late Animation<Offset> transTween;

  late final ScrollController scrollController;
  late int breadId;
  RxInt gotDibsUserCount = 5.obs;
  RxBool isGotDibs = false.obs;

  RxBool breadLikeBtnShow = false.obs;
  RxBool isLoading = true.obs;
  RxBool firstInitLoading = true.obs;

  late BreadDetailInfo? breadDetailInfo;
  BreadDetailInfo? __breadDetailInfo = BreadDetailInfo.fromJson({
    'id': 9,
    'name': '다로복숭아크림빵',
    'thumbnail': null,
    'costPrice': 4200,
    'price': 3730,
    'discount': 11,
    'description': '생 복숭아가 씹히는 복숭아크림빵',
    'detailDescription': null,
    'isGotDibs': false,
  }, {
    'id': 1,
    'name': '다로베이커리',
    'thumbnail': null,
    'bakeryFeatures': [
      {'id': '1', 'filter': "우리밀"},
      {'id': '2', 'filter': '천연발효'}
    ]
  }, 5);
  @override
  void onInit() async {
    breadId = Get.arguments['breadId'];
    scrollController = new ScrollController();
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

    await _fetchBreadDetailInfo();

    firstInitLoading(false);
    super.onInit();
  }

  @override
  void onClose() {
    ColorAnimationController.dispose();
    TextAnimationController.dispose();

    scrollController.dispose();
    super.onClose();
  }

  bool scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      var calcScrollEventAppearValue = scrollInfo.metrics.pixels / 35.0.h;
      ColorAnimationController.animateTo(calcScrollEventAppearValue);
      if (calcScrollEventAppearValue >= 1) {
        breadLikeBtnShow(true);
      } else {
        breadLikeBtnShow(false);
      }
    }
    return false;
  }

// =======================
// Fetch Logic
// -----------------------

  Future<void> _fetchBreadDetailInfo() async {
    print('여기까지는옵니가');
    breadDetailInfo =
        await fetchBreadDetail(breadId: breadId, isLoading: isLoading);
  }

  Future<void> toggleGetDibsBread() async {
    return Future(() async {
      try {
        if (isGotDibs.value == true) {
          isGotDibs(false);
          gotDibsUserCount -= 1;
        } else {
          isGotDibs(true);
          gotDibsUserCount += 1;
        }
        final result = await FindPageApi.toggleGetDibsBread(breadId: breadId);
        final toggleDibsBreadResult = result.data?['toggleDibsBakery'];

        if (toggleDibsBreadResult['ok'] == false) {
          showSnackBar(message: "잠시 후에 다시 시도해 주세요.");
          if (isGotDibs.value == true) {
            isGotDibs(false);
            gotDibsUserCount -= 1;
          } else {
            isGotDibs(true);
            gotDibsUserCount += 1;
          }
        }
        print(result);
      } catch (e) {
        print(e);
      }
    });
  }
}
