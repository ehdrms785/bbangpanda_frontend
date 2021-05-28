import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/FindBread/model/bakeryFilterController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedValues.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

var isShowAppBar = true.obs;

// 택배 / 매장취식만 따로 분리하기
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
    print("바이");
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GraphQLConfiguration.setToken('token!!!');
    // print('현재 저장된 토큰 체크 홈 :${LocalStorage('newUser').getItem('token')}');

    // print(
    //     '바뀐 토큰 : token : ${GraphQLConfiguration.httpLink.defaultHeaders.values.first}');

    print("hello world");
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
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
                    IconButton(
                        icon: Icon(Icons.access_alarm), onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.zoom_out_outlined), onPressed: () {})
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                height: 7.0.h,
                child: CustomScrollView(
                  key: Key("커스텀"),
                  physics: NeverScrollableScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      // snap: true,
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
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    BakeryListTab(),
                    HelloWorld(),
                    HelloWorld(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BakeryListTab extends StatefulWidget {
  @override
  _BakeryListTabState createState() => _BakeryListTabState();
}

class _BakeryListTabState extends State<BakeryListTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        isShowAppBar(true);
      } else {
        isShowAppBar(false);
      }
      print(_scrollController.position.userScrollDirection);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  final BakeryFilterController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(MediaQuery.of(context).viewInsets.top);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 10.0.h,
              color: Colors.grey.shade500,
              child: Center(
                child: Text("신규입점 베이커리ㅋ"),
              ),
            ),
          ),
          SliverToBoxAdapter(child: Divider()),
          SliverAppBar(
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
                    // alignment: Alignment.centerRight,
                    // color: Colors.blue.shade500,
                    width: double.infinity,
                    height: 5.0.h,
                    // padding: EdgeInsets.symmetric(vertical: 1.0.h),
                    child: Row(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ...(controller.bakeryFilterResult
                                            .where((e) {
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
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          selected: false,
                                          selectedColor:
                                              Colors.blueAccent.shade200,
                                        ),
                                      );
                                    }),
                                  ],
                                ))),
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: () async {
                            showModalBottomSheet(
                              isDismissible:
                                  false, // 위에 빈공간 눌렀을때 자동으로 없어지게 하는 기능
                              isScrollControlled: true, // 풀 스크린 가능하게 만들어줌
                              context: context,
                              builder: (context) {
                                controller.tempFilterIdList.clear();
                                controller.tempFilterIdList
                                    .addAll(controller.filterIdList);
                                print("여기보자");
                                print(controller.tempFilterIdList);
                                print(controller.filterIdList);
                                return Container(
                                    width: 100.0.w,
                                    height: 90.0.h,
                                    child: Obx(() {
                                      if (controller.tempFilterIdList.length ==
                                          0) {
                                        controller.fetchBakeryFilter();
                                      }
                                      if (controller.filterLoading.value) {
                                        return Center(
                                            child:
                                                CupertinoActivityIndicator());
                                      }

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.0.w),
                                        child: Column(
                                          // mainAxisSize: MainAxisSize.max,

                                          children: [
                                            MyAppBar(title: "필터"),
                                            Container(
                                              width: double.infinity,
                                              child: Wrap(
                                                alignment:
                                                    WrapAlignment.spaceEvenly,
                                                spacing: 0.0,
                                                runSpacing: 0.0,
                                                children: [
                                                  ...controller
                                                      .bakeryFilterResult
                                                      .asMap()
                                                      .entries
                                                      .map((MapEntry entry) {
                                                    return ChoiceChip(
                                                      disabledColor:
                                                          Colors.grey.shade700,
                                                      selectedColor: Colors
                                                          .blueAccent.shade200,
                                                      selected: controller
                                                          .tempFilterIdList
                                                          .contains(
                                                              (entry.key + 1)
                                                                  .toString()),
                                                      onSelected: (value) {
                                                        if (controller
                                                                    .tempFilterIdList
                                                                    .length ==
                                                                1 &&
                                                            value == false) {
                                                          showSnackBar(
                                                              message:
                                                                  "최소 1개 이상의 필터는 선택되어야 합니다");
                                                          return;
                                                        }

                                                        controller
                                                                .tempFilterIdList
                                                                .contains((entry
                                                                            .key +
                                                                        1)
                                                                    .toString())
                                                            ? controller
                                                                .tempFilterIdList
                                                                .remove((entry
                                                                            .key +
                                                                        1)
                                                                    .toString())
                                                            : controller
                                                                .tempFilterIdList
                                                                .add((entry.key +
                                                                        1)
                                                                    .toString());
                                                      },
                                                      label: Text(
                                                          entry.value['filter'],
                                                          style: TextStyle()),
                                                    );
                                                  })
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.5.h),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        width: 30.0.w,
                                                        height: 5.0.h,
                                                        child: ElevatedButton(
                                                          child: Text("초기화",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                          onPressed: () {
                                                            controller
                                                                .initFilterSelected();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                                Colors.white,
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
                                                            controller
                                                                .applyFilterChanged();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(),
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
                              },
                            ).whenComplete(() {
                              print("종료");
                              return;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: Divider()),
          Obx(() {
            if (controller.isLoading.value == true &&
                controller.bakeriesResult.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            return SliverFillRemaining(
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: controller.bakeriesResult.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.bakeriesResult.length) {
                        if (controller.hasMore.value == false) {
                          return Divider(
                            height: 3.0,
                            thickness: 2.0,
                          );
                        }
                        if (controller.bakeriesResult.length > 4) {
                          return CupertinoActivityIndicator(
                            key: ValueKey(index),
                          );
                        } else {
                          return Visibility(
                              key: ValueKey(index),
                              visible: false,
                              child: Container());
                        }
                      }
                      return Container(
                        key: ValueKey(index),
                        // color: Colors
                        height: 35.0.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.bakeriesResult[index]!['name'],
                              style: TextStyle(
                                  fontSize: 15.0.sp,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Builder(
                              builder: (context) {
                                final List<dynamic> result = controller
                                    .bakeriesResult[index]!['bakeryFeatures']
                                    .where((e) => int.parse(e['id']) > 2)
                                    .toList();
                                print("테스트값 결과");

                                print(result);
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
                            Text(
                              controller
                                      .bakeriesResult[index]!['description'] ??
                                  '소개 없음',
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Builder(
                              builder: (context) {
                                final List<dynamic> result = controller
                                    .bakeriesResult[index]!['signitureBreads']
                                    .map((value) => value['name'])
                                    .toList();

                                return Row(children: [
                                  Text('대표빵: '),
                                  ...result.map((element) => Text('#$element ',
                                      style: TextStyle(
                                          fontSize: 10.0.sp,
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w300))),
                                ]);
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
                        ),
                      );
                    },
                  ),
                  Visibility(
                    visible: controller.isLoading.value,
                    child: Opacity(
                      opacity: 0.3,
                      child: new ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.isLoading.value,
                    child: Container(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  // if (!controller.isLoading.value) CupertinoActivityIndicator()
                ],
              ),
            );
            return GetBuilder<BakeryFilterController>(
              builder: (controller) {
                return SliverList(
                  key: Key("BLKey"), // BakeryList Key
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      print("아이템 빌더 : 인덱스 $index");
                      print("length :${controller.bakeriesResult.length}");
                      print("hasMore :${controller.hasMore.value}");
                      if (index == controller.bakeriesResult.length) {
                        if (controller.hasMore.value == false) {
                          return Divider(
                            height: 3.0,
                            thickness: 2.0,
                          );
                        }
                        if (controller.bakeriesResult.length > 4) {
                          return CupertinoActivityIndicator(
                            key: ValueKey(index),
                          );
                        } else {
                          return Visibility(
                              key: ValueKey(index),
                              visible: false,
                              child: Container());
                        }
                      }
                      return Container(
                        key: ValueKey(index),
                        // color: Colors
                        height: 35.0.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.bakeriesResult[index]!['name'],
                              style: TextStyle(
                                  fontSize: 15.0.sp,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Builder(
                              builder: (context) {
                                final List<dynamic> result = controller
                                    .bakeriesResult[index]!['bakeryFeatures']
                                    .where((e) => int.parse(e['id']) > 2)
                                    .toList();
                                print("테스트값 결과");

                                print(result);
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
                            Text(
                              controller
                                      .bakeriesResult[index]!['description'] ??
                                  '소개 없음',
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Builder(
                              builder: (context) {
                                final List<dynamic> result = controller
                                    .bakeriesResult[index]!['signitureBreads']
                                    .map((value) => value['name'])
                                    .toList();

                                return Row(children: [
                                  Text('대표빵: '),
                                  ...result.map((element) => Text('#$element ',
                                      style: TextStyle(
                                          fontSize: 10.0.sp,
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w300))),
                                ]);
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
                        ),
                      );
                    },
                    childCount: controller.bakeriesResult.length + 1,
                  ),
                );
              },
            );
          }),
          SliverToBoxAdapter(
            child: Container(
                height: 5.0.h,
                color: Colors.grey,
                child: TextButton(
                    onPressed: () async {
                      controller.fetchMoreFilterBakeries();
                    },
                    child: Text("펫치모어"))),
          ),
        ],
      ),
    );
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
