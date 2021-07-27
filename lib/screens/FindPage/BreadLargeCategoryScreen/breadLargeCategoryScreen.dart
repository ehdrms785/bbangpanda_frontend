import 'package:bbangnarae_frontend/screens/FindPage/BreadLargeCategoryScreen/breadLargeCategoryController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/BreadSmallCategoryScreen/breadSmallCategoryScreen.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

// var isShowAppBar = true.obs;

class BreadLargeCategoryScreen extends StatelessWidget {
  final BreadLargeCategoryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
          isShowAppBar: controller.isShowAppBar,
          title: controller.breadLargeCategory.category,
          actions: appBarActions,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CupertinoActivityIndicator());
          }
          return DefaultTabController(
            length: controller.smallCategoriesResult.length + 1,
            initialIndex: 0,
            child: Padding(
              // padding: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
              child: Column(
                children: [
                  TabListContainer(),
                  TabViewList(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> appBarActions = [
    GestureDetector(
      onTap: () {
        print("TAB");
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5.w),
        child: Icon(Icons.access_alarm),
      ),
    ),
    GestureDetector(
      onTap: () {
        print("TAB");
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5.w),
        child: Icon(Icons.zoom_out_outlined),
      ),
    ),
  ];

  Widget TabListContainer() => CustomScrollView(
        key: Key("BLCS"), // BakeryLargetCategoryScroll
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // controller: controller.scrollController,
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
          child: DecoratedTabBar(
            tabBar: TabBar(
                controller: controller.tabController,
                isScrollable: true,
                physics: NeverScrollableScrollPhysics(),
                unselectedLabelColor: Colors.grey.withOpacity(0.3),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                indicatorWeight: 0.5.h,
                tabs: [
                  SizedBox(
                    height: 5.0.h,
                    child: Tab(
                      child: Text("전체", style: TextStyle(fontSize: 13.0.sp)),
                    ),
                  ),
                  ...controller.smallCategoriesResult.map(
                    (smallCategory) => SizedBox(
                        height: 5.0.h,
                        child: Tab(
                          child: Text(smallCategory['category'],
                              style: TextStyle(fontSize: 13.0.sp)),
                        )),
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
          children: <Widget>[
            // 전체탭
            BreadSmallCategoryTab(
              largeCategoryId: controller.breadLargeCategory.id,
            ),
            // 나머지탭
            ...controller.smallCategoriesResult.map(
              (smallCategory) => BreadSmallCategoryTab(
                largeCategoryId: controller.breadLargeCategory.id,
                smallCategoryId: smallCategory['id'],
              ),
            ),
          ],
        ),
      );
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
    return Container(
        child: CustomScrollView(slivers: [
      SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45.0.w,
                height: 25.0.h,
                child: Image.asset(
                  'assets/breadImage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Text("가격 나오고", style: TextStyle(fontSize: 12.0.sp)),
              Text("베이커리명", style: TextStyle(fontSize: 12.0.sp)),
              Text("대충설명", style: TextStyle(fontSize: 12.0.sp)),
            ],
          );
        }, childCount: 5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0.w,
          mainAxisExtent: 40.0.h,
        ),
      ),
    ]));
  }
}
