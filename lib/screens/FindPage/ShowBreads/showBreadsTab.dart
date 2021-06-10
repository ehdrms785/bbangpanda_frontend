import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class ShowBreadsTab extends StatefulWidget {
  ShowBreadsTab({Key? key, this.isShowAppBar}) : super(key: key);
  late final isShowAppBar;
  @override
  _ShowBreadsTabState createState() => _ShowBreadsTabState();
}

class _ShowBreadsTabState extends State<ShowBreadsTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  final ShowBreadsController controller = Get.find();
  @override
  void initState() {
        print("ShowBreads Init!");
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.isShowAppBar(true);
      } else {
        widget.isShowAppBar(false);
        if (_scrollController.position.pixels + 50 >=
                _scrollController.position.maxScrollExtent &&
            !controller.isFetchMoreLoading &&
            controller.hasMore.value) {
          print("FetchMore 실행 !");
          // Future.microtask(() => controller.fetchMoreFilterBakeries());
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
          // 처음 로딩 돌아갈 때 굳이 밑에 이중로딩 돌아가지 않게
          // 하려는 작업!
          child: controller.isLoading.value
              ? Container()
              : CustomScrollView(
                  key: ValueKey('breadScroll'),
                  controller: _scrollController,
                  slivers: [
                    NewBreadBox(),
                    SliverToBoxAdapter(child: Divider()),
                    CategoryBar(),
                    SliverToBoxAdapter(child: Divider()),
                    BreadList(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget NewBreadBox() => SliverToBoxAdapter(
        child: Container(
          height: 10.0.h,
          color: Colors.grey.shade500,
          child: Center(
            child: Text("새로 나온 빵 구역"),
          ),
        ),
      );
  Widget CategoryBar() => SliverAppBar(
        pinned: true,
        toolbarHeight: 0, // bottom을 Title로 쓰기 위해
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5.0.h),
          child: GetBuilder<ShowBreadsController>(
            id: "breadCategoryBar",
            builder: (controller) {
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
                            ...controller.breadLargeCategories.map((e) {
                              return GestureDetector(
                                onTap: () {
                                  print('id값은 : ${e['id']}');
                                  Get.toNamed('/breadLargeCategory/${e["id"]}');
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 2.0.w),
                                  child: RawChip(
                                    selected: e['id'] == 0 ? true : false,
                                    selectedColor: Colors.black,
                                    label: Text(e['category'],
                                        style: TextStyle(
                                            color: e['id'] == 0
                                                ? Colors.white
                                                : Colors.black54,
                                            fontSize: 11.0.sp,
                                            fontWeight: FontWeight.w600)),
                                    showCheckmark: false,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
  Widget FilterModal() {
    // TempFilterIdList는 현재 filterIdList를 복사한 값으로 사용
    controller.tempFilterIdList.clear();
    controller.tempFilterIdList.addAll(controller.filterIdList);
    return Container(
        width: 100.0.w,
        height: 90.0.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w),
          child: Obx(() {
            List<Widget> filterWidgetList = [];
            controller.bakeryFilterResult
                .asMap()
                .entries
                .forEach((MapEntry entry) {
              filterWidgetList.add(MakeChoiceChip(entry));
              if (entry.key == 1) {
                filterWidgetList.add(Divider());
              }
            });
            return Column(
              children: [
                MyAppBar(title: "필터"),
                Container(
                  width: double.infinity,
                  child: Wrap(
                      spacing: 2.0.w,
                      runSpacing: 0.0,
                      children: [...filterWidgetList]),
                ),

                // 맨 아래에 버튼을 두기 위한 Expanded
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
            );
          }),
        ));

    // Obx(() {
    //   controller.bakeryFilterResult;
    //   // 처음 ShowBreadsController를 초기화 할 때
    //   // FetchBakeryFilter를 하기 때문에 굳이 필요 없을 것 같지만
    //   // 남겨두는 이유는.. 인터넷 사용이 끊겨있는 상태에서
    //   // 결과를 받아왔다가 다시 요청하게 될 경우를 염두해두는것..
    //   // if (controller.tempFilterIdList.length == 0) {
    //   //   controller.fetchBakeryFilter();
    //   // }
    //   // if (controller.filterLoading.value) {
    //   //   return Center(child: CupertinoActivityIndicator());
    //   // }

    //   return Padding(
    //     padding: EdgeInsets.symmetric(horizontal: 4.0.w),
    //     child: Column(
    //       // mainAxisSize: MainAxisSize.max,

    //       children: [
    //         MyAppBar(title: "필터"),
    //         Builder(
    //           builder: (context) {
    //             List<Widget> filterWidget = [];

    //             controller.bakeryFilterResult
    //                 .asMap()
    //                 .entries
    //                 .forEach((MapEntry entry) {
    //               filterWidget.add(MakeChoiceChip(entry));
    //               if (entry.key == 1) {
    //                 filterWidget.add(Divider());
    //               }
    //             });
    //             return Container(
    //               width: double.infinity,
    //               child: Wrap(
    //                   // alignment: WrapAlignment.start,
    //                   // alignment: WrapAlignment.spaceEvenly,
    //                   spacing: 0.0,
    //                   runSpacing: 0.0,
    //                   children: [...filterWidget]),
    //             );
    //           },
    //         ),

    //         // 맨 아래에 버튼을 두기 위한 Expanded
    //         Expanded(
    //           child: Align(
    //             alignment: Alignment.bottomCenter,
    //             child: Container(
    //               padding: EdgeInsets.symmetric(vertical: 2.5.h),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   SizedBox(
    //                     width: 30.0.w,
    //                     height: 5.0.h,
    //                     child: ElevatedButton(
    //                       child: Text("초기화",
    //                           style: TextStyle(color: Colors.black)),
    //                       onPressed: () {
    //                         controller.initFilterSelected();
    //                       },
    //                       style: ElevatedButton.styleFrom(
    //                         primary: Colors.white,
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     width: 50.0.w,
    //                     height: 5.0.h,
    //                     child: ElevatedButton(
    //                       child: Text("적용"),
    //                       onPressed: () async {
    //                         Get.back();
    //                         controller.applyFilterChanged();
    //                       },
    //                       style: ElevatedButton.styleFrom(),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   );
    // },
    // ));
  }

  Widget MakeChoiceChip(MapEntry entry) => ChoiceChip(
        disabledColor: Colors.grey.shade700,
        selectedColor: Colors.blueAccent.shade200,
        selected:
            controller.tempFilterIdList.contains((entry.key + 1).toString()),
        onSelected: (value) {
          if (controller.tempFilterIdList.length == 1 && value == false) {
            showSnackBar(message: "최소 1개 이상의 필터는 선택되어야 합니다");
            return;
          }
          // 택배가능, 매장취식 건들 때

          if (value == false) {
            if ((entry.key + 1 == 1 &&
                    !controller.tempFilterIdList.contains('2')) ||
                (entry.key + 1 == 2 &&
                    !controller.tempFilterIdList.contains('1'))) {
              // 택배가능을 끄려고 하는데 매장취식이 꺼져있는경우
              // 매장취식 끄려고 하는데 택배가능도 꺼져있는 경우

              showSnackBar(message: "택배가능 | 매장취식 중 1개 이상의 필터는 선택되어야 합니다");
              return;
            }
          }

          controller.tempFilterIdList.contains((entry.key + 1).toString())
              ? controller.tempFilterIdList.remove((entry.key + 1).toString())
              : controller.tempFilterIdList.add((entry.key + 1).toString());
        },
        label: Text(entry.value['filter'], style: TextStyle()),
      );
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
  Widget BreadList() {
    return MixinBuilder<ShowBreadsController>(
        id: "bakeryList",
        builder: (controller) {
          if (controller.isLoading.value == true &&
              controller.breadsResult.isEmpty) {
            return SliverIndicator();
          }

          return SliverGrid(
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
          );
        });
    // hasMore를 이 부분에서 넣어주지 않으면
    // hasMore가 바뀌어도 밑에 SliverList의 Indicator가
    // 변하지 않는다. (그래서 일단 이곳에 넣었다)
  }
}
