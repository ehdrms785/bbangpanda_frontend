import 'package:bbangnarae_frontend/screens/FindPage/ShowMarketOrders/marketOrderShareWidget.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowMarketOrders/showMarketOrdersController.dart';
import 'package:bbangnarae_frontend/shared/loader.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShowMarketOrdersTab extends StatefulWidget {
  const ShowMarketOrdersTab({Key? key}) : super(key: key);

  @override
  _ShowMarketOrdersTabState createState() => _ShowMarketOrdersTabState();
}

class _ShowMarketOrdersTabState extends State<ShowMarketOrdersTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final ShowMarketOrdersController controller;

  @override
  void initState() {
    print("ShowMarketOrdersTab Init!!");
    Get.create(() => ShowMarketOrdersController(), tag: 'showMarketTab');
    controller = Get.find(tag: 'showMarketTab');
    _scrollController = controller.scrollController;
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
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
              child: controller.firstInitLoading.value
                  ? Loader()
                  : CustomScrollView(
                      key: ValueKey('marketOrderScroll'),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                          parent: const AlwaysScrollableScrollPhysics()),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () =>
                              controller.refreshMarketOrderInfoData,
                        ),
                        MarketFilterBar(controller),
                        SimpleMarketOrerList(
                            isLoading: controller.isLoading,
                            hasMore: controller.hasMore,
                            simpleMarketOrdersListResult:
                                controller.simpleMarketOrdersListResult)
                      ],
                    )),
        ),
      ),
    );
  }
}
