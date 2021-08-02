import 'package:auto_size_text/auto_size_text.dart';
import 'package:bbangnarae_frontend/screens/FindPage/ShowMarketOrders/marketOrderModel.dart';
import 'package:bbangnarae_frontend/shared/sharedFunction.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget SimpleMarketOrerList(
    {required RxBool isLoading,
    required RxBool hasMore,
    required RxList<dynamic> simpleMarketOrdersListResult}) {
  List<Color> colorList = [
    Color.fromRGBO(88, 142, 111, 0.9),
    //rgb(104, 119, 110)1145 147 136
    Color.fromRGBO(145, 147, 136, 0.9),
    //rgb(201, 139, 188) rgb(200, 119, 188) rgb(219, 122, 198) gb(196, 172, 191)
    //174 144 147
    Color.fromRGBO(174, 144, 147, 1.0),
    //180 107 122 220 134 153
    Color.fromRGBO(180, 107, 122, 0.7),
  ];
  return Obx(() {
    if (isLoading.value == true && simpleMarketOrdersListResult.isEmpty) {
      return SliverIndicator();
    }
    return SliverList(
      key: ValueKey("MOLKey"), // MakretOrderList Key
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == simpleMarketOrdersListResult.length) {
          if (hasMore.value == false) {
            if (simpleMarketOrdersListResult.length == 0) {
              return Container(
                height: 50.0.h,
                child: Center(
                  child: Text(
                    "해당 조건의 마켓이 없어요.",
                    style: TextStyle(fontSize: 20.0.sp),
                  ),
                ),
              );
            }
            return Divider(
              height: 3.0.h,
              thickness: 2.0,
            );
          }
          if (simpleMarketOrdersListResult.length > 0) {
            return CupertinoActivityIndicator(
              key: ValueKey(index),
            );
          } else {
            return Container();
          }
        }
        MarketOrderSimpleInfo marketOrderData =
            simpleMarketOrdersListResult[index];

        print("index: $index");
        print(
            '출발일 ${marketOrderData.orderStartDate} 마감일 ${marketOrderData.orderEndDate}');
        return Container(
          margin: EdgeInsets.symmetric(vertical: 2.0.h),
          decoration: BoxDecoration(
            color: Colors.green.shade900
                .withRed(80 * (index % 4))
                .withOpacity(0.3),
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          key: ValueKey(index),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.white.withOpacity(0.1)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 1.0.h,
                    ),
                    child: Center(
                      child: AutoSizeText(
                        marketOrderData.orderName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0.sp),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 12.0.w,
                        child: Divider(
                          indent: 10.0,
                          thickness: 1.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 0.5.h),
                        child: Text(
                          "라인업",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1.0,
                        endIndent: 10.0,
                        color: Colors.white,
                      ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0.w,
                      vertical: 1.0.h,
                    ),
                    child: ConstrainedBox(
                      constraints: new BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: 0,
                        maxHeight: 14.0.h,
                      ),
                      child: Wrap(
                        clipBehavior: Clip.antiAlias,
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          ...marketOrderData.lineUpBreads
                              .asMap()
                              .map((index, lineUpBread) {
                                return MapEntry(
                                  index,
                                  Text(
                                    '▪${lineUpBread.name}',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              })
                              .values
                              .toList(),
                          // // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...marketOrderData.signitureBreadList
                          .takeWhile((value) =>
                              marketOrderData.signitureBreadList
                                  .indexOf(value) <
                              2)
                          .map
                          // ...marketOrderData
                          //     .signitureBreadList
                          //     .map
                          ((signitureBread) {
                        return Stack(
                          children: [
                            Container(
                              width: 46.0.w,
                              height: 20.0.h,
                              child: Image.asset(
                                signitureBread.thumbnail!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              child: Text(
                                "✔️ 대표메뉴",
                                style: TextStyle(
                                  fontSize: 8.0.sp,
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              top: 5,
                              left: 5,
                            ),
                            Positioned.fill(
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  height: 3.0.h,
                                  color: Colors.grey.shade600.withOpacity(0.3),
                                  child: Text(
                                    signitureBread.name,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11.0.sp),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                    ],
                  ),
                  Container(
                    height: 8.0.h,
                    child: Row(
                      children: [
                        Builder(builder: (context) {
                          String filters = '';
                          for (var item
                              in marketOrderData.marketOrderFeatures) {
                            filters += '#${item.filter} ';
                          }

                          return Expanded(
                            child: Container(
                              height: 8.0.h,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.0.w,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        // width: 12.0.w,
                                        child: Divider(
                                          indent: 10.0,
                                          thickness: 1.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 5, right: 5, top: 0.5.h),
                                        child: Text(
                                          "주요 빵특징",
                                          style: TextStyle(
                                              fontSize: 9.0.sp,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      Expanded(
                                          child: Divider(
                                        thickness: 1.0,
                                        endIndent: 10.0,
                                        color: Colors.white,
                                      ))
                                    ],
                                  ),
                                  Text(
                                    filters,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 9.0.sp, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        Container(
                          width: 46.0.w,
                          height: 8.0.h,
                          alignment: Alignment.center,
                          child: Builder(
                            builder: (context) {
                              DateTime startDate =
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                      marketOrderData.orderStartDate));

                              print("StartDate: $startDate");
                              DateTime endDate =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(marketOrderData.orderEndDate));

                              print("EndDate: $endDate");
                              int entirePeriod =
                                  calcEntirePeriod(startDate, endDate);
                              int remainedHours = calcRemainedHours(endDate);

                              double remainBarValue =
                                  (remainedHours / entirePeriod);

                              print(
                                  'entirePeriod: $entirePeriod // remainedHours: $remainedHours // remainBarValue: $remainBarValue');

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '판매 종료: ${remainedHours >= 24 ? 'D-${remainedHours ~/ 24}일 후 마감' : remainedHours > 0 ? '$remainedHours시간 후 마감' : '마감'}',
                                          style: TextStyle(
                                              fontSize: 9.0.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.0.w),
                                    child: LinearProgressIndicator(
                                      value: remainBarValue.isNaN
                                          ? 0
                                          : remainBarValue,
                                      minHeight: 1.0.h,
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          colorList[index % 4]),
                                    ),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.5.w),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "${startDate.month.toString().padLeft(2, '0')}/${startDate.day.toString().padLeft(2, '0')} ${startDate.hour}:${startDate.minute.toString().padLeft(2, '0')}",
                                                style: TextStyle(
                                                    fontSize: 8.0.sp)),
                                          ),
                                          Expanded(
                                              child: Center(child: Text('~'))),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')} ${endDate.hour}:${endDate.minute.toString().padLeft(2, '0')}",
                                                style: TextStyle(
                                                    fontSize: 8.0.sp)),
                                          ),
                                        ],
                                      ))
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }, childCount: simpleMarketOrdersListResult.length + 1),
    );
  });
}

Widget MarketFilterBar(MarketOrderModel controller) {
  return SliverAppBar(
      pinned: true,
      toolbarHeight: 0, // bottom을 Title로 쓰기 위해
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(6.0.h),
        child: Column(
          children: [
            Container(
              height: 5.0.h,
              margin: EdgeInsets.only(bottom: 0.5.h),
              // color: Colors.amber.shade100,
              child: Row(
                // scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        isScrollControlled: true,
                        context: Get.context!,
                        builder: (context) {
                          return Obx(
                            () => Wrap(
                              children: [
                                MyAppBar(title: "정렬 설정"),
                                ...MarketOrderSortFilters.map((sortFilter) =>
                                    ListTile(
                                      onTap: () {
                                        controller.sortFilterId(sortFilter.id);
                                        controller.refreshMarketOrderInfoData;
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
                        margin: EdgeInsets.only(right: 2.0.w),
                        child: RawChip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(
                            "${MarketOrderSortFilters.where((element) => element.id == controller.sortFilterId.value).first.filter} ∇",
                            style: TextStyle(
                                fontSize: 9.0.sp, fontWeight: FontWeight.w600),
                          ),
                          labelPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // showCheckmark: false,
                          padding: EdgeInsets.all(5.0),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.transparent,
                          showCheckmark: false,
                        )),
                  ),
                  FilterIcon(controller),
                  Center(
                      child: Text(' | ', style: TextStyle(color: Colors.grey))),
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
                          stops: [0.0, 0.02, 0.97, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstOut,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(width: 2.0.w),
                          ...(controller.marketOrderFilterResult
                                  .where((filter) {
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
                ],
              ),
            ),
          ],
        ),
      ));
  // controller as ShowMarketOrdersController;
  // if (controller.runtimeType == SearchMarketOrderController)
  //   controller as SearchMarketOrderController;
}

Widget FilterIcon(MarketOrderModel controller) => GestureDetector(
      child: RawChip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          "상세옵션 ∇",
          style: TextStyle(fontSize: 9.0.sp, fontWeight: FontWeight.w600),
        ),
        labelPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0, color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        showCheckmark: false,
        padding: EdgeInsets.all(5.0),
        backgroundColor: Colors.transparent,
      ),
      onTap: () async {
        showModalBottomSheet(
          isDismissible: false, // 위에 빈공간 눌렀을때 자동으로 없어지게 하는 기능
          isScrollControlled: true, // 풀 스크린 가능하게 만들어줌
          context: Get.context!,
          builder: (context) {
            // return Container();
            return FilterModal(controller);
          },
        ).whenComplete(() {
          print("종료");
          return;
        });
      },
    );
Widget FilterModal(MarketOrderModel controller) {
  // controller as ShowMarketOrdersController;
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
          controller.marketOrderFilterResult
              .asMap()
              .entries
              .forEach((MapEntry entry) {
            filterWidgetList
                .add(MakeChoiceChip(controller.tempFilterIdList, entry));
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

Widget MakeChoiceChip(RxList<dynamic> tempFilterIdList, MapEntry entry) =>
    ChoiceChip(
      disabledColor: Colors.grey.shade700,
      selectedColor: Colors.blueAccent.shade200,
      selected: tempFilterIdList.contains((entry.key + 1).toString()),
      onSelected: (value) {
        // 택배가능, 매장취식 건들 때

        tempFilterIdList.contains((entry.key + 1).toString())
            ? tempFilterIdList.remove((entry.key + 1).toString())
            : tempFilterIdList.add((entry.key + 1).toString());
      },
      label: Text(entry.value['filter'], style: TextStyle()),
    );
