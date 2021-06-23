import 'package:bbangnarae_frontend/screens/FindPage/BreadLargeCategoryScreen/breadLargeCategoryController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadShareWidget.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsController.dart';
import 'package:bbangnarae_frontend/screens/FindPage/support/findPagetypeDef.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

// 카테고리 & 필터2줄로 나눠보자
class ShowBreadsTab extends StatefulWidget {
  ShowBreadsTab({Key? key, required this.isShowAppBar}) : super(key: key);
  late final RxBool isShowAppBar;
  @override
  _ShowBreadsTabState createState() => _ShowBreadsTabState();
}

class _ShowBreadsTabState extends State<ShowBreadsTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final ShowBreadsController controller;
  @override
  void initState() {
    print("ShowBreads Init!");
    Get.create(() => ShowBreadsController(isShowAppBar: widget.isShowAppBar),
        tag: 'showBreadTab');
    controller = Get.find(tag: 'showBreadTab');
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
    print("showBreads 빌드 체크");
// Get.find(tag: )
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
        child: Obx(
          () => ModalProgressScreen(
            isAsyncCall: controller.isLoading.value,
            // 처음 로딩 돌아갈 때 굳이 밑에 이중로딩 돌아가지 않게
            // 하려는 작업!
            child: CustomScrollView(
              key: ValueKey('breadScroll'),
              controller: _scrollController,
              // shrinkWrap: true,
              // physics: BouncingScrollPhysics(),
              physics: const BouncingScrollPhysics(
                  parent: const AlwaysScrollableScrollPhysics()),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () => controller.refreshBakeryInfoData(),
                ),
                NewBreadBox(),
                CategoryBar(),
                SliverToBoxAdapter(
                    child: Divider(
                  height: 1,
                )),
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 2.0.h,
                )),
                // BreadList(controller: controller),
                SliverToBoxAdapter(
                    child: Container(
                        color: Colors.pink.shade400,
                        child:
                            Center(child: Text("여기는 다양한 추천 상품이 들어가는 곳으로 만들자"))))
              ],
            ),
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
              child: Chip(
            label: Text("새로 나온 빵 구역",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11.0.sp,
                    fontWeight: FontWeight.w600)),
          )),
        ),
      );
  Widget CategoryBar() => SliverAppBar(
        pinned: true,
        toolbarHeight: 0, // bottom을 Title로 쓰기 위해

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.5.h),
          child: Container(
            height: 6.5.h,
            // color: Colors.amber.shade100,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Obx(
                          () => Wrap(
                            children: [
                              MyAppBar(title: "정렬 설정"),
                              ...BreadSortFilters.map((sortFilter) => ListTile(
                                    onTap: () {
                                      controller.sortFilterId(sortFilter.id);
                                      controller.refreshBakeryInfoData();
                                      Get.back();
                                    },
                                    title: Text(sortFilter.filter),
                                    selected: sortFilter.id ==
                                        controller.sortFilterId.value,
                                    selectedTileColor: Colors.grey,
                                  )),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      // margin: EdgeInsets.only(left: 2.0.w),
                      child: RawChip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(
                      "${BreadSortFilters.where((element) => element.id == controller.sortFilterId.value).first.filter} ∇",
                      style: TextStyle(
                          fontSize: 9.0.sp, fontWeight: FontWeight.w600),
                    ),
                    labelPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                    )),
                    showCheckmark: false,
                    padding: EdgeInsets.all(5.0),
                  )),
                ),
                Text(' |', style: TextStyle(color: Colors.grey)),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Colors.black,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.0, 0.05, 0.95, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 2.0.w),
                        ...BreadCategories.map((e) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed('/breadLargeCategory');
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 2.0.w),
                              child: RawChip(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                label: Text(
                                  e.category,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 9.0.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 0.3.w),
                                showCheckmark: false,
                              ),
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
          ),
        ),
      );
  Widget FilterIcon() => GestureDetector(
        child: Icon(Icons.filter_list),
        onTap: () async {
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
  Widget FilterModal() {
    // TempFilterIdList는 현재 filterIdList를 복사한 값으로 사용
    // controller.tempFilterIdList.clear();
    // controller.tempFilterIdList.addAll(controller.filterIdList);
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
  Widget SliverIndicator() => SliverToBoxAdapter(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
}
// hasMore를 이 부분에서 넣어주지 않으면
// hasMore가 바뀌어도 밑에 SliverList의 Indicator가
// 변하지 않는다. (그래서 일단 이곳에 넣었다)
