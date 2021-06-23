import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBakeries/bakeryModel.dart';
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
            child: controller.firstInitLoading.value
                ? Center(child: CupertinoActivityIndicator())
                : CustomScrollView(
                    key: ValueKey('bakeryScroll'),
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                        parent: const AlwaysScrollableScrollPhysics()),
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () => controller.refreshBakeryInfoData(),
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
              child: Obx(() {
                if (controller.filterLoading.value) {
                  return Center(child: CupertinoActivityIndicator());
                }
                return Row(
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
                                  ...BakerySortFilters.map((sortFilter) =>
                                      ListTile(
                                        onTap: () {
                                          controller
                                              .sortFilterId(sortFilter.id);
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(
                            "${BakerySortFilters.where((element) => element.id == controller.sortFilterId.value).first.filter} ∇",
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
                        ),
                      ),
                    ),
                    Text(' ㅣ', style: TextStyle(color: Colors.grey)),
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
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Text(
                                    e['filter'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 9.0.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
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
                );
              }),
            )),
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

  Widget BakeryList() {
    return Obx(
      () {
        // Obx의 단점이 SliverList 안에 hasMoreValue가 있으면
        // 해당을 반영해서 UI 업데이트를 하지 않는다.
        // 그래서 이렇게 명시적으로 써 준다.
        controller.hasMore.value;
        if (controller.isLoading.value == true &&
            controller.simpleBakeriesListResult.isEmpty) {
          return SliverIndicator();
        }
        return SliverList(
          key: ValueKey("BLKey"), // BakeryList Key
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == controller.simpleBakeriesListResult.length) {
                print("마지막 인덱스 하하");
                // 더 이상 아이템이 없을 때
                if (controller.hasMore.value == false) {
                  if (controller.simpleBakeriesListResult.length == 0) {
                    return Container(
                      height: 50.0.h,
                      child: Center(
                          child: Text("해당 조건의 빵집이 없어요.",
                              style: TextStyle(fontSize: 20.0.sp))),
                    );
                  }
                  print("마지막 인덱스 hasMore : False ");
                  return Divider(
                    height: 3.0.h,
                    thickness: 2.0,
                  );
                }
                if (controller.simpleBakeriesListResult.length > 0) {
                  return CupertinoActivityIndicator(
                    key: ValueKey(index),
                  );
                } else {
                  return Visibility(
                      key: ValueKey(index), visible: false, child: Container());
                }
              }
              BakerySimpleInfo bakeryData =
                  controller.simpleBakeriesListResult[index];
              return Container(
                key: ValueKey(index),
                // height: 35.0.h,
                child: Builder(
                  builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 8.0.h,
                          child: Wrap(
                            direction: Axis.vertical,
                            children: [
                              Container(
                                width: 10.0.w,
                                height: double.maxFinite,
                                padding: EdgeInsets.zero,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    image: new AssetImage(bakeryData.thumbnail),
                                  ),
                                ),
                              ),
                              Container(width: 2.0.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bakeryData.name,
                                    style: TextStyle(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      final List<dynamic> result = bakeryData
                                          .bakeryFeature
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        bakeryData.description == null
                            ? Container()
                            : Text(
                                bakeryData.description ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                        bakeryData.signitureBreads?.length == 0
                            ? Container()
                            : Row(
                                children: [
                                  Text(
                                    '대표빵: ',
                                    style: TextStyle(
                                        fontSize: 9.0.sp,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  ...bakeryData.signitureBreads!.map(
                                    (element) => Text(
                                      '$element ',
                                      style: TextStyle(
                                          fontSize: 9.0.sp,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
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
                        Divider(
                          height: 4.0.h,
                        )
                      ],
                    );
                  },
                ),
              );
            },
            childCount: controller.simpleBakeriesListResult.length + 1,
          ),
        );
      },
    );
  }
  // hasMore를 이 부분에서 넣어주지 않으면
  // hasMore가 바뀌어도 밑에 SliverList의 Indicator가
  // 변하지 않는다. (그래서 일단 이곳에 넣었다)

}
