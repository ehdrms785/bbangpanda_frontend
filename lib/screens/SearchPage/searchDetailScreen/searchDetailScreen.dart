import 'package:bbangnarae_frontend/screens/SearchPage/searchBakeriesScreen/searchBakeriesScreen.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchBreadsScreen/searchBreadsScreen.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchDetailScreen/searchDetailScreenController.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchMarketsScreen/searchMarketsScreen.dart';
import 'package:bbangnarae_frontend/screens/SearchPage/searchScreenSharedWidget.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchDetailScreen extends StatefulWidget {
  const SearchDetailScreen({Key? key}) : super(key: key);
  @override
  _SearchDetailScreenState createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  Key key = UniqueKey();
  final controller = Get.find<SearchDetailScreenController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SearchScreenAppBar(context, controller,
            onSubmit: searchDetailOnSubmit),
        body: Column(
          key: key,
          children: [
            TabListContainer(),
            TabViewList(),
            // Container(
            //   child: Obx(() => Column(
            //         children: [
            //           Text(controller.termTextController.value.text),
            //           Wrap(
            //             spacing: 2.0.w,
            //             runSpacing: 0,
            //             children: [
            //               ...controller.recentSearchTerms.map(
            //                 (recentTerm) => RawChip(
            //                   label: Text(recentTerm,
            //                       style: TextStyle(fontSize: 12.0.sp)),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       )),
            // ),
          ],
        ),
      ),
    );
  }

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
                // physics: NeverScrollableScrollPhysics(),
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
            SearchBakriesScreen(),
            SearchBreadsScreen(),
            SearchMarketOrders(),
          ],
        ),
      );

  void searchDetailOnSubmit(String val) {
    if (val == '' || val.length < 2) {
      showSnackBar(message: "최소 1자 이상의 검색어를 입력 해 주세요");
      return;
    }
    controller.updateRecentSearchTerm();
    setState(() {
      key = UniqueKey();
    });
    // controller.update(['searchDetailTabView']);
    // controller.termTextController.update((val) {});
  }
}

class HelloWorld extends StatefulWidget {
  @override
  _HelloWorldState createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("헬로베이비");
    return Container();
  }
}
