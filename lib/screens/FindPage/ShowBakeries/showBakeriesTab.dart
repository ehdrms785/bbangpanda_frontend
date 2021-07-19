import 'package:bbangnarae_frontend/screens/BakeryDetailPage/bakeryDetailMainScreen.dart/bakeryDetailMainController.dart';
import 'package:bbangnarae_frontend/screens/BakeryDetailPage/bakeryDetailMainScreen.dart/bakeryDetailMainScreen.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryShareWidget.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/showBakeriesController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class ShowBakeriesTab extends StatefulWidget {
  @override
  _ShowBakeriesTabState createState() => _ShowBakeriesTabState();
}

class _ShowBakeriesTabState extends State<ShowBakeriesTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final ShowBakeriesController controller;

  @override
  void initState() {
    print("ShowBakeries Init!");
    Get.create(() => ShowBakeriesController(), tag: 'showBakeryTab');
    controller = Get.find(tag: 'showBakeryTab');
    _scrollController = controller.scrollController;
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w),
        child: Obx(
          () => ModalProgressScreen(
            isAsyncCall: controller.isLoading.value,
            // 처음 로딩 돌아갈 때 굳이 밑에 이중로딩 돌아가지 않게
            // 하려는 작업!
            child: controller.firstInitLoading.value
                ? Center(child: CupertinoActivityIndicator())
                : CustomScrollView(
                    key: ValueKey('bakeryScroll'),
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                        parent: const AlwaysScrollableScrollPhysics()),
                    slivers: [
                      CupertinoSliverRefreshControl(
                          onRefresh: () => controller.refreshBakeryInfoData),
                      NewBakeryBox(),
                      BakeryFilterBar(controller),
                      SliverToBoxAdapter(
                          child: Divider(
                        height: 1,
                      )),
                      SliverToBoxAdapter(
                          child: SizedBox(
                        height: 1.0.h,
                      )),
                      SimpleBakeryList(
                          isLoading: controller.isLoading,
                          hasMore: controller.hasMore,
                          simpleBakeriesListResult:
                              controller.simpleBakeriesListResult),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget NewBakeryBox() => SliverToBoxAdapter(
        child: GestureDetector(
          //임시
          onTap: () {
            print("탭했습니다");
            Get.to(BakeryDetailMainScreen(), arguments: {'bakeryId': 1},
                binding: BindingsBuilder(() {
              Get.lazyPut(() => BakeryDetailMainController());
            }));
          },
          child: Container(
            height: 10.0.h,
            color: Colors.grey.shade500,
            child: Center(
              child: Text("신규입점 베이커리 구역",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11.0.sp,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      );

  // hasMore를 이 부분에서 넣어주지 않으면
  // hasMore가 바뀌어도 밑에 SliverList의 Indicator가
  // 변하지 않는다. (그래서 일단 이곳에 넣었다)

}
