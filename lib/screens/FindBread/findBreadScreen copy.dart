import 'package:bbangnarae_frontend/screens/FindBread/model/bakeryFilterController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

// 수정 테스트 전 백업

var isShowAppBar = true.obs;

class FindBread extends StatefulWidget {
  @override
  _FindBreadState createState() => _FindBreadState();
}

class _FindBreadState extends State<FindBread>
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
                IconButton(icon: Icon(Icons.access_alarm), onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.zoom_out_outlined), onPressed: () {})
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
                    child: Center(child: Text("빵집")),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 10.0.w,
                    child: Center(child: Text("빵")),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 15.0.w,
                    child: Center(child: Text("즐겨찾기")),
                  ),
                ),
              ]),
        ),
      );
  Widget TabViewList() => Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            BakeryListTab(),
            HelloWorld(),
            HelloWorld(),
          ],
        ),
      );
}

class BakeryListTab extends StatefulWidget {
  @override
  _BakeryListTabState createState() => _BakeryListTabState();
}

class _BakeryListTabState extends State<BakeryListTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  final BakeryFilterController controller = Get.find();
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        isShowAppBar(true);
      } else {
        isShowAppBar(false);
        if (_scrollController.position.pixels + 50 >=
                _scrollController.position.maxScrollExtent &&
            !controller.isFetchMoreLoading &&
            controller.hasMore.value) {
          print("FetchMore 실행 !");
          Future.microtask(() => controller.fetchMoreFilterBakeries());
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
      child: Obx(
        () => ModalProgressScreen(
          isAsyncCall: controller.isLoading.value,
          child: CustomScrollView(
            key: ValueKey('bakeryScroll'),
            controller: _scrollController,
            slivers: [
              NewBakeryBox(),
              SliverToBoxAdapter(child: Divider()),
              FilterBar(),
              SliverToBoxAdapter(child: Divider()),
              BakeryList(),

              // SliverToBoxAdapter(
              //   child: Container(
              //       height: 5.0.h,
              //       color: Colors.grey,
              //       child: TextButton(
              //           onPressed: () async {
              //             controller.fetchMoreFilterBakeries();
              //           },
              //           child: Text("펫치모어"))),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget NewBakeryBox() => SliverToBoxAdapter(
        child: Container(
          height: 10.0.h,
          color: Colors.grey.shade500,
          child: Center(
            child: Text("신규입점 베이커리 구역"),
          ),
        ),
      );
  Widget FilterBar() => SliverAppBar(
        pinned: true,
        toolbarHeight: 0, // bottom을 Title로 쓰기 위해
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5.0.h),
          child: GetBuilder<BakeryFilterController>(
            id: "filterBar",
            builder: (controller) {
              if (controller.filterLoading.value) {
                return Center(child: CupertinoActivityIndicator());
              }
              return Container(
                width: double.infinity,
                height: 5.0.h,
                child: Row(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...(controller.bakeryFilterResult.where((e) {
                                  if (controller.filterIdList
                                      .contains(e['id'])) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                }).toList())
                                    .map((e) {
                                  print(e);
                                  return Padding(
                                    padding: EdgeInsets.only(right: 2.0.w),
                                    child: ChoiceChip(
                                      label: Text(e['filter'],
                                          style:
                                              TextStyle(color: Colors.black)),
                                      selected: false,
                                      selectedColor: Colors.blueAccent.shade200,
                                    ),
                                  );
                                }),
                              ],
                            ))),
                    FilterIcon(),
                  ],
                ),
              );
            },
          ),
        ),
      );
  Widget FilterModal() {
    controller.tempFilterIdList.clear();
    controller.tempFilterIdList.addAll(controller.filterIdList);
    print("여기보자");
    print(controller.tempFilterIdList);
    print(controller.filterIdList);
    return Container(
        width: 100.0.w,
        height: 90.0.h,
        child: Obx(() {
          if (controller.tempFilterIdList.length == 0) {
            controller.fetchBakeryFilter();
          }
          if (controller.filterLoading.value) {
            return Center(child: CupertinoActivityIndicator());
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: Column(
              // mainAxisSize: MainAxisSize.max,

              children: [
                MyAppBar(title: "필터"),
                Container(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 0.0,
                    runSpacing: 0.0,
                    children: [
                      ...controller.bakeryFilterResult
                          .asMap()
                          .entries
                          .map((MapEntry entry) {
                        return ChoiceChip(
                          disabledColor: Colors.grey.shade700,
                          selectedColor: Colors.blueAccent.shade200,
                          selected: controller.tempFilterIdList
                              .contains((entry.key + 1).toString()),
                          onSelected: (value) {
                            if (controller.tempFilterIdList.length == 1 &&
                                value == false) {
                              showSnackBar(message: "최소 1개 이상의 필터는 선택되어야 합니다");
                              return;
                            }

                            controller.tempFilterIdList
                                    .contains((entry.key + 1).toString())
                                ? controller.tempFilterIdList
                                    .remove((entry.key + 1).toString())
                                : controller.tempFilterIdList
                                    .add((entry.key + 1).toString());
                          },
                          label:
                              Text(entry.value['filter'], style: TextStyle()),
                        );
                      })
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 30.0.w,
                            height: 5.0.h,
                            child: ElevatedButton(
                              child: Text("초기화",
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                controller.initFilterSelected();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50.0.w,
                            height: 5.0.h,
                            child: ElevatedButton(
                              child: Text("적용"),
                              onPressed: () async {
                                Get.back();
                                controller.applyFilterChanged();
                              },
                              style: ElevatedButton.styleFrom(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }));
  }

  Widget FilterIcon() => IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: () async {
          showModalBottomSheet(
            isDismissible: false, // 위에 빈공간 눌렀을때 자동으로 없어지게 하는 기능
            isScrollControlled: true, // 풀 스크린 가능하게 만들어줌
            context: context,
            builder: (context) {
              return FilterModal();
            },
          ).whenComplete(() {
            print("종료");
            return;
          });
        },
      );
  Widget SliverIndicator() => SliverToBoxAdapter(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
  Widget BakeryList() {
    return MixinBuilder<BakeryFilterController>(
      id: "bakeryList",
      builder: (controller) {
        if (controller.isLoading.value == true &&
            controller.bakeriesResult.isEmpty) {
          return SliverIndicator();
        }
        return SliverList(
          key: ValueKey("BLKey"), // BakeryList Key
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == controller.bakeriesResult.length) {
                print("마지막 인덱스");
                // 더 이상 아이템이 없을 때
                if (controller.hasMore.value == false) {
                  print("마지막 인덱스 들어옴");
                  return Divider(
                    height: 3.0,
                    thickness: 2.0,
                  );
                }
                // 아이템이 너무 적을 때는 Indicator가 나오지 않게
                if (controller.bakeriesResult.length > 1) {
                  return CupertinoActivityIndicator(
                    key: ValueKey(index),
                  );
                } else {
                  return Visibility(
                      key: ValueKey(index), visible: false, child: Container());
                }
              }
              return Container(
                key: ValueKey(index),
                height: 35.0.h,
                child: Builder(
                  builder: (context) {
                    final bakeryResultList = controller.bakeriesResult[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bakeryResultList['name'],
                          style: TextStyle(
                              fontSize: 15.0.sp, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        Builder(
                          builder: (context) {
                            final List<dynamic> result =
                                bakeryResultList['bakeryFeatures']
                                    .where((e) => int.parse(e['id']) > 2)
                                    .toList();

                            return Row(children: [
                              ...result.map((element) => Text(
                                  '#${element['filter']} ',
                                  style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w300))),
                            ]);
                          },
                        ),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        Visibility(
                          visible: bakeryResultList['description'] == null
                              ? false
                              : true,
                          child: Column(
                            children: [
                              Text(
                                bakeryResultList['description'] ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 1.0.h,
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final List<dynamic> result =
                                bakeryResultList['signitureBreads']
                                    .map((value) => value['name'])
                                    .toList();

                            return Visibility(
                              visible: result.length != 0,
                              child: Row(children: [
                                Text('대표빵: '),
                                ...result.map((element) => Text('$element ',
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w300))),
                              ]),
                            );
                          },
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                width: 30.0.w,
                                height: 20.0.h,
                                child: Image.asset(
                                  'assets/breadImage.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 30.0.w,
                                height: 20.0.h,
                                child: Image.asset(
                                  'assets/breadImage.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 30.0.w,
                                height: 20.0.h,
                                child: Image.asset(
                                  'assets/breadImage.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
            childCount: controller.bakeriesResult.length + 1,
          ),
        );
      },
    );
  }
  // hasMore를 이 부분에서 넣어주지 않으면
  // hasMore가 바뀌어도 밑에 SliverList의 Indicator가
  // 변하지 않는다. (그래서 일단 이곳에 넣었다)

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
