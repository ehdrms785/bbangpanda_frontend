import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadModel.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/breadShareWidget.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowBreads/showBreadsController.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final isInit = false;

class BreadSmallCategoryTab extends StatefulWidget {
  const BreadSmallCategoryTab(
      {Key? key,
      required this.isShowAppBar,
      required this.largeCategoryId,
      this.smallCategoryId})
      : super(key: key);
  final String largeCategoryId;
  final String? smallCategoryId;
  final RxBool isShowAppBar;
  @override
  _BreadSmallCategoryTabState createState() => _BreadSmallCategoryTabState();
}

class _BreadSmallCategoryTabState extends State<BreadSmallCategoryTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final ShowBreadsController controller;
  @override
  void initState() {
    print("ShowBreads Init!");
    Get.create(
        () => ShowBreadsController(
            isShowAppBar: widget.isShowAppBar,
            breadLargeCategoryId: widget.largeCategoryId,
            breadSmallCategoryId: widget.smallCategoryId),
        tag: '${widget.largeCategoryId}/${widget.smallCategoryId}breadTab');
    controller = Get.find(
        tag: '${widget.largeCategoryId}/${widget.smallCategoryId}breadTab');
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
    print("BreadSmallCateogryScreen 빌드!");
    return Scaffold(
      body: Obx(() => ModalProgressScreen(
            isAsyncCall: controller.isLoading.value,
            child: controller.firstInitLoading.value
                ? Center(child: CupertinoActivityIndicator())
                : CustomScrollView(
                    key: ValueKey(widget.largeCategoryId),
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                        parent: const AlwaysScrollableScrollPhysics()),
                    slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () => Future(() => null),
                        ),
                        FilterBar(),
                        BreadList(controller: controller),
                      ]),
          )),
    );
  }

  Widget FilterBar() => SliverAppBar(
      pinned: true,
      toolbarHeight: 0, // bottom을 Title로 쓰기 위해
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(6.0.h),
        child: Container(
          width: double.infinity,
          height: 5.0.h,
          margin: EdgeInsets.symmetric(vertical: 0.5.h),
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
                  margin: EdgeInsets.only(left: 2.0.w),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: RawChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        "${BreadSortFilters.where((element) => element.id == controller.sortFilterId.value).first.filter} ∇",
                        style: TextStyle(
                            fontSize: 9.0.sp, fontWeight: FontWeight.w600),
                      ),
                      showCheckmark: false,
                    ),
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
                        if (controller.filterIdList.contains(filter['id'])) {
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
          ),
        ),
      ));
  Widget FilterIcon() => IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: () async {
          showModalBottomSheet(
            isDismissible: false, // 위에 빈공간 눌렀을때 자동으로 없어지게 하는 기능
            isScrollControlled: true, // 풀 스크린 가능하게 만들어줌
            context: context,
            builder: (context) {
              return Container();
              // return FilterModal();
            },
          ).whenComplete(() {
            print("종료");
            return;
          });
        },
      );
  // Widget FilterModal() {
  //   // TempFilterIdList는 현재 filterIdList를 복사한 값으로 사용
  //   // controller.tempFilterIdList.clear();
  //   // controller.tempFilterIdList.addAll(controller.filterIdList);
  //   return Container(
  //       width: 100.0.w,
  //       height: 90.0.h,
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 4.0.w),
  //         child: Obx(() {
  //           List<Widget> filterWidgetList = [];
  //           controller.bakeryFilterResult
  //               .asMap()
  //               .entries
  //               .forEach((MapEntry entry) {
  //             filterWidgetList.add(MakeChoiceChip(entry));
  //             if (entry.key == 1) {
  //               filterWidgetList.add(Divider());
  //             }
  //           });
  //           return Column(
  //             children: [
  //               MyAppBar(title: "필터"),
  //               Container(
  //                 width: double.infinity,
  //                 child: Wrap(
  //                     spacing: 2.0.w,
  //                     runSpacing: 0.0,
  //                     children: [...filterWidgetList]),
  //               ),

  //               // 맨 아래에 버튼을 두기 위한 Expanded
  //               Expanded(
  //                 child: Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Container(
  //                     padding: EdgeInsets.symmetric(vertical: 2.5.h),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         SizedBox(
  //                           width: 30.0.w,
  //                           height: 5.0.h,
  //                           child: ElevatedButton(
  //                             child: Text("초기화",
  //                                 style: TextStyle(color: Colors.black)),
  //                             onPressed: () {
  //                               controller.initFilterSelected();
  //                             },
  //                             style: ElevatedButton.styleFrom(
  //                               primary: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 50.0.w,
  //                           height: 5.0.h,
  //                           child: ElevatedButton(
  //                             child: Text("적용"),
  //                             onPressed: () async {
  //                               Get.back();
  //                               controller.applyFilterChanged();
  //                             },
  //                             style: ElevatedButton.styleFrom(),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           );
  //         }),
  //       ));
  // }
}
