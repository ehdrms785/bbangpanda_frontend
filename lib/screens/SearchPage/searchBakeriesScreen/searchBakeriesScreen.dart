import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryShareWidget.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadShareWidget.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchBakeriesScreen/searchBakeriesController.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchBreadsScreen/searchBreadsController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchBakriesScreen extends StatefulWidget {
  @override
  _SearchBakriesScreenState createState() => _SearchBakriesScreenState();
}

class _SearchBakriesScreenState extends State<SearchBakriesScreen>
    with AutomaticKeepAliveClientMixin {
  // late final ScrollController _scrollController;
  late final SearchBakeriesController controller;

  @override
  void initState() {
    print("ShowBreads Init!");
    Get.create(() => SearchBakeriesController(), tag: 'searchBakeries');
    controller = Get.find(tag: 'searchBakeries');

    // _scrollController = controller.scrollController;

    super.initState();
  }

  @override
  void dispose() {
    print("SearchBakeries Dispose!!");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("SearchBakriesScreenState 빌드!");
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
        child: Obx(() => ModalProgressScreen(
              isAsyncCall: controller.isLoading.value,
              child: controller.firstInitLoading.value
                  ? Center(child: CupertinoActivityIndicator())
                  : CustomScrollView(
                      // key: ValueKey(),
                      controller: controller.scrollController,
                      physics: const BouncingScrollPhysics(
                          parent: const AlwaysScrollableScrollPhysics()),
                      slivers: [
                          CupertinoSliverRefreshControl(
                              onRefresh: () =>
                                  controller.refreshBakeryInfoData),
                          BakeryFilterBar(controller),
                          SimpleBakeryList(
                              isLoading: controller.isLoading,
                              hasMore: controller.hasMore,
                              simpleBakeriesListResult:
                                  controller.simpleBakeriesListResult),
                        ]),
            )),
      ),
    );
  }
}
