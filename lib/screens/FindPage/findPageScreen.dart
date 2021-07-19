import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/showBakeriesTab.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsTab.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowMarketOrders/showMarketOrdersScreen.dart';
import 'package:bbangnarae_frontend/screens/FindPage/findpageScreenController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class FindPageScreen extends GetView<FindPageScreenController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar:
              MainAppBar(isShowAppBar: controller.isShowAppBar, title: "빵쇼핑"),
          body: Column(
            children: [
              TabListContainer(),
              TabViewList(),
            ],
          ),
        ),
      ),
    );
  }

  // PreferredSizeWidget MainAppBar() => PreferredSize(
  //       preferredSize: Size.fromHeight(5.0.h),
  //       child: Obx(
  //         () => AnimatedContainer(
  //           height: controller.isShowAppBar.value ? 5.0.h : 0.0,
  //           duration: Duration(milliseconds: 200),
  //           child: AppBar(
  //             title: Text("빵쇼핑"),
  //             centerTitle: true,
  //             leading: Icon(Icons.ac_unit_sharp),
  //             actions: [
  //               GestureDetector(
  //                 onTap: () {
  //                   Get.toNamed('/search');
  //                 },
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 1.5.w),
  //                   child: Icon(
  //                     Icons.search,
  //                     color: Colors.grey,
  //                     size: 20.0.sp,
  //                   ),
  //                 ),
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   print("TAB");
  //                 },
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 1.5.w),
  //                   child: Icon(
  //                     Icons.shopping_cart_outlined,
  //                     color: Colors.grey,
  //                     size: 20.0.sp,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  Widget TabListContainer() => CustomScrollView(
        key: Key("MainScroll"),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          TabList(),
        ],
      );
  Widget TabList() => SliverAppBar(
        pinned: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 7.0.h,
        titleSpacing: 0,
        title: Container(
          width: double.infinity,
          // color: Colors.grey,
          child: DecoratedTabBar(
            tabBar: TabBar(
                controller: controller.tabController,

                // isScrollable: true,
                physics: NeverScrollableScrollPhysics(),
                unselectedLabelColor: Colors.grey.withOpacity(0.3),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                indicatorWeight: 0.5.h,
                labelPadding: EdgeInsets.zero,
                tabs: [
                  SizedBox(
                    height: 5.0.h,
                    child: Tab(
                      child: Center(
                          child:
                              Text("빵집", style: TextStyle(fontSize: 12.0.sp))),
                    ),
                  ),
                  SizedBox(
                    height: 5.0.h,
                    child: Tab(
                      child: Center(
                          child:
                              Text("빵", style: TextStyle(fontSize: 12.0.sp))),
                    ),
                  ),
                  SizedBox(
                    height: 5.0.h,
                    child: Tab(
                      child: Center(
                          child:
                              Text("마켓", style: TextStyle(fontSize: 12.0.sp))),
                    ),
                  ),
                ]),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.1,
                ),
              ),
            ),
          ),
        ),
      );
  Widget TabViewList() => Expanded(
        child: TabBarView(
          controller: controller.tabController,
          // physics: NeverScrollableScrollPhysics(),
          physics: CustomPageViewScrollPhysics(),
          children: <Widget>[
            ShowBakeriesTab(),
            ShowBreadsTab(),
            ShowMarketOrdersTab(),
          ],
        ),
      );
}
