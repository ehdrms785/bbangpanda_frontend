import 'package:bbangnarae_frontend/screens/FindPage/ShowMarketOrders/marketOrderShareWidget.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchMarketsScreen/searchMarketsController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchMarketOrders extends StatefulWidget {
  @override
  _SearchMarketOrdersState createState() => _SearchMarketOrdersState();
}

class _SearchMarketOrdersState extends State<SearchMarketOrders>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final SearchMarketOrderController controller;

  @override
  void initState() {
    print("ShowBreads Init!");
    Get.create(() => SearchMarketOrderController(), tag: 'searchMarketOrders');
    controller = Get.find(tag: 'searchMarketOrders');
    _scrollController = controller.scrollController;
    super.initState();
  }

  @override
  void dispose() {
    print("SearchMarketOrders Dispose!!");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w),
        child: Obx(
          () => ModalProgressScreen(
              isAsyncCall: controller.isLoading.value,
              child: controller.firstInitLoading.value
                  ? Center(child: CupertinoActivityIndicator())
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
