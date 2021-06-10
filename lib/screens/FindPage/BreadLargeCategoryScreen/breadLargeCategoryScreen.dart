import 'package:bbangnarae_frontend/screens/FindPage/BreadLargeCategoryScreen/breadLargeCategoryController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/BreadSmallCategoryScreen/breadCategory.dart';
import 'package:bbangnarae_frontend/screens/FindPage/BreadSmallCategoryScreen/breadSmallCategoryScreen.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

var isShowAppBar = true.obs;

class BreadLargeCategoryScreen extends StatelessWidget {
  final BreadLargeCategoryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: MainAppBar(),
          body: Padding(
            // padding: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 3.0.w),
            child: Column(
              children: [
                TabListContainer(),
                TabViewList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget MainAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: Obx(
          () => AnimatedContainer(
            height: isShowAppBar.value ? 5.0.h : 0.0,
            duration: Duration(milliseconds: 200),
            child: AppBar(
              title: Text("대분류"),
              centerTitle: true,
              actions: [
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
              ],
            ),
          ),
        ),
      );
  Widget TabListContainer() => Container(
        height: 15.0.h,
        // padding: EdgeInsets.symmetric(horizontal: 3.0.w),
        color: Colors.blue.withOpacity(0.2),
        child: CustomScrollView(
          key: Key("BLCS"), // BakeryLargetCategoryScroll
          physics: NeverScrollableScrollPhysics(),
          controller: controller.scrollController,
          slivers: [
            TabList(),
            SliverToBoxAdapter(
              child: Divider(),
            )
          ],
        ),
      );
  Widget TabList() => SliverAppBar(
        pinned: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: TabBar(
                  controller: controller.tabController,
                  isScrollable: true,
                  physics: NeverScrollableScrollPhysics(),
                  unselectedLabelColor: Colors.grey.withOpacity(0.3),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorWeight: 0.2.h,
                  tabs: [
                    Tab(
                      child: Text("전체", style: TextStyle(fontSize: 13.0.sp)),
                    ),
                    Tab(
                      child: Text("식빵", style: TextStyle(fontSize: 13.0.sp)),
                    ),
                    Tab(
                      child: Text("치아바타", style: TextStyle(fontSize: 13.0.sp)),
                    ),
                    Tab(
                      child: Text("크림빵", style: TextStyle(fontSize: 13.0.sp)),
                    ),
                  ]),
            ),
          ],
        ),
        bottom: PreferredSize(
          child: Column(
            children: [
              Divider(
                height: 0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  // color: Colors.red.withOpacity(0.4),
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: Row(
                    children: [
                      RawChip(
                        label: Text("최신순"),
                      ),
                      RawChip(
                        label: Text("가격"),
                      ),
                      RawChip(
                        label: Text("옵션"),
                      ),
                      RawChip(
                        label: Text("테스트용으로 길~~~~게"),
                      ),
                      RawChip(
                        label: Text("아차차차차타ㅏ하"),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
              ),
            ],
          ),
          preferredSize: Size.fromHeight(7.8.h),
        ),
        shadowColor: Colors.red,
      );
  Widget TabViewList() => Expanded(
        child: TabBarView(
          controller: controller.tabController,
          children: <Widget>[
            KeepAliveWrapper(
              child: BreadSmallCategoryScreen(
                largeCategory: BreadLargeCategory.all,
              ),
            ),
            // KeepAliveWrapper(
            //   child: BreadSmallCategoryTest(
            //     largeCategory: BreadLargeCategory.all,
            //   ),
            // ),
            KeepAliveWrapper(
              child: BreadSmallCategoryScreen(
                largeCategory: BreadLargeCategory.softBread,
              ),
            ),
            // KeepAliveWrapper(
            //   child: BreadSmallCategoryTest(
            //     largeCategory: BreadLargeCategory.softBread,
            //   ),
            // ),

            BreadSmallCategoryScreen(
              largeCategory: BreadLargeCategory.hardBread,
            ),
            BreadSmallCategoryScreen(
              largeCategory: BreadLargeCategory.dessert,
            ),
            // HelloWorld(),
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
              Text("가격 나오고"),
              Text("베이커리명"),
              Text("대충설명"),
            ],
          );
        }, childCount: 5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0.w,
          mainAxisExtent: 35.0.h,
        ),
      ),
    ]));
  }
}
