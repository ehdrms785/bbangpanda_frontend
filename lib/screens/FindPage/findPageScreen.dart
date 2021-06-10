import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/showBakeriesTab.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsTab.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

var isShowAppBar = true.obs;

class FindPageScreen extends StatefulWidget {
  @override
  _FindPageScreenState createState() => _FindPageScreenState();
}

class _FindPageScreenState extends State<FindPageScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: MainAppBar(),
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

  PreferredSizeWidget MainAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: Obx(
          () => AnimatedContainer(
            height: isShowAppBar.value ? 5.0.h : 0.0,
            duration: Duration(milliseconds: 200),
            child: AppBar(
              title: Text("마켓"),
              centerTitle: true,
              leading: Icon(Icons.ac_unit_sharp),
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
        height: 7.0.h,
        child: CustomScrollView(
          key: Key("MainScroll"),
          physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [TabList()],
        ),
      );
  Widget TabList() => SliverAppBar(
        pinned: true,
        title: Container(
          width: double.infinity,
          child: TabBar(
              controller: _tabController,
              isScrollable: true,
              physics: NeverScrollableScrollPhysics(),
              unselectedLabelColor: Colors.grey.withOpacity(0.3),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              indicatorWeight: 0.2.h,
              tabs: [
                Tab(
                  child: Container(
                    width: 10.0.w,
                    child: Center(
                        child: Text("빵집", style: TextStyle(fontSize: 13.0.sp))),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 10.0.w,
                    child: Center(
                        child: Text("빵", style: TextStyle(fontSize: 13.0.sp))),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 18.0.w,
                    child: Center(
                        child:
                            Text("즐겨찾기", style: TextStyle(fontSize: 13.0.sp))),
                  ),
                ),
              ]),
        ),
      );
  Widget TabViewList() => Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            ShowBakeriesTab(
              isShowAppBar: isShowAppBar,
            ),
            ShowBreadsTab(
              isShowAppBar: isShowAppBar,
            ),
            HelloWorld(),
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
    return Container();
  }
}
