import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/showBakeriesController.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class ShowBakeriesTab extends StatefulWidget {
  ShowBakeriesTab({Key? key, this.isShowAppBar}) : super(key: key);
  late final isShowAppBar;
  @override
  _ShowBakeriesTabState createState() => _ShowBakeriesTabState();
}

class _ShowBakeriesTabState extends State<ShowBakeriesTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final ShowBakeriesController controller;

  @override
  void initState() {
    print("ShowBakeries Init!");
    Get.create(() => ShowBakeriesController(isShowAppBar: widget.isShowAppBar),
        tag: 'showBakeryTab');
    controller = Get.find(tag: 'showBakeryTab');
    _scrollController = controller.scrollController;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
        child: Obx(
          () => ModalProgressScreen(
            isAsyncCall: controller.isLoading.value,
            // 처음 로딩 돌아갈 때 굳이 밑에 이중로딩 돌아가지 않게
            // 하려는 작업!
            child: CustomScrollView(
              key: ValueKey('bakeryScroll'),
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                  parent: const AlwaysScrollableScrollPhysics()),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () => controller.applyFilterChanged(),
                ),
                NewBakeryBox(),
                FilterBar(),
                SliverToBoxAdapter(
                    child: Divider(
                  height: 1,
                )),
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 2.0.h,
                )),
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
      ),
    );
  }

  Widget NewBakeryBox() => SliverToBoxAdapter(
        child: Container(
          height: 10.0.h,
          color: Colors.grey.shade500,
          child: Center(
            child: Text("신규입점 베이커리 구역",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11.0.sp,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      );
  Widget FilterBar() => SliverAppBar(
        pinned: true,
        toolbarHeight: 0, // bottom을 Title로 쓰기 위해
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: Container(
              width: double.infinity,
              height: 6.5.h,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(left: 2.0.w),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RawChip(
                          label: Text("최신순"),
                        ),
                      ),
                    ),
                  ),
                  Text(' ㅣ', style: TextStyle(color: Colors.grey)),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...(controller.bakeryFilterResult.where((filter) {
                            if (controller.filterIdList
                                .contains(filter['id'])) {
                              return true;
                            } else {
                              return false;
                            }
                          }).toList())
                              .map((e) {
                            return Padding(
                              padding: EdgeInsets.only(right: 2.0.w),
                              child: RawChip(
                                label: Text(e['filter'],
                                    style: TextStyle(color: Colors.black)),
                                selected: false,
                                selectedColor: Colors.blueAccent.shade200,
                                showCheckmark: false,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  FilterIcon(),
                ],
              ),
            )),
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
    //   // 처음 ShowBakeriesController를 초기화 할 때
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
  Widget BakeryList() {
    return Obx(
      () {
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
                  if (controller.bakeriesResult.length == 0) {
                    return Container(
                      height: 50.0.h,
                      child: Center(
                          child: Text("해당 조건의 빵집이 없어요 (빵..)",
                              style: TextStyle(fontSize: 20.0.sp))),
                    );
                  }
                  print("마지막 인덱스 hasMore : False ");
                  return Divider(
                    height: 3.0.h,
                    thickness: 2.0,
                  );
                }
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
                // height: 35.0.h,
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
                                      fontSize: 9.0.sp,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 27.0.w,
                                height: 20.0.h,
                                child: Image.asset(
                                  'assets/breadImage.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 27.0.w,
                                height: 20.0.h,
                                child: Image.asset(
                                  'assets/breadImage.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 27.0.w,
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
